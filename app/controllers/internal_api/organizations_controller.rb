class InternalApi::OrganizationsController < InternalApi::ApplicationController
  before_action :authenticate_user

  def create
    new_org = Organization.new organization_params
    if params[:logo].present?
      image_url_code = AwsS3.instance.upload 'org-logo', params[:logo]
      new_org.logo = image_url_code
    end
    new_org.creator = current_user
    Organization.transaction do
      new_org.save!
      OrgMembership.create!(organization: new_org, user: current_user, role: :admin)
    end
    render json: {message: '组织创建成功!'}, status: 200
  rescue => error
    message = new_org.errors.full_messages.to_sentence
    message = message.presence || error.message
    render json: {message: message}, status: 500
  end

  def update
    org = Organization.find_by(name: params[:name])
    return render json: {message: '未找到组织'}, status: 404 unless org
    authorize org

    # 更新组织的信息
    org.assign_attributes(organization_params)

    if params[:logo].present?
      image_url_code = AwsS3.instance.upload 'org-logo', params[:logo]
      org.logo = image_url_code
    end
    
    # 保存组织信息
    if org.save
      render json: {message: '组织更新成功'}
    else
      render json: {message: "组织更新失败"}, status: 500
    end
  rescue Pundit::NotAuthorizedError
    render json: {message: '更新未授权!'}, status: 401
  end
  
  def new_members
    unless OrgMembership.roles.keys.include? params[:user_role]
      return render json: {message: '请提供角色信息'}, status: 400
    end

    user_names = params[:user_names].split(',').map(&:strip)
    return render json: {message: '请提供成员信息'}, status: 400 unless user_names.present?

    org = Organization.find_by(name: params[:org_name])
    return render json: {message: '未找到组织'}, status: 404 unless org
    return render json: {message: '未授权，请联系管理员'} if current_user.org_role(org) != 'admin'

    Organization.transaction do
      user_names.each do |user_name|
        user = User.find_by(name: user_name)
        # 不允许改自己的角色
        next if current_user == user
        next unless user
        user_org_role = user.org_role(org)
        if !user_org_role
          OrgMembership.create!(organization: org, user: user, role: params[:user_role])
          sync_create_membership(org, user)
        elsif user_org_role == params[:user_role]
          next
        else
          user.set_org_role(org, params[:user_role])
          sync_update_membership(org, user, user_org_role)
        end
      end
    end
    render json: {message: '添加组织成员成功'}
  rescue => e
    render json: {message: "添加组织成员失败, #{e.message}"}, status: 400
  end

  def models
    render json: Starhub.api.get_org_models(params[:namespace], current_user&.name, { per: params[:per] })
  end

  def datasets
    render json: Starhub.api.get_org_datasets(params[:namespace], current_user&.name, { per: params[:per] })
  end

  private

  def organization_params
    params.permit(:name, :nickname, :homepage, :org_type)
  end

  def sync_create_membership(org, user)
    res = Starhub.api.create_membership(org.name, current_user.name, params[:user_role], user.name)
    raise StarhubError, res.body unless res.success?
  end

  def sync_delete_membership(org, user, role)
    res = Starhub.api.delete_membership(org.name, current_user.name, role, user.name)
    raise StarhubError, res.body unless res.success?
  end

  def sync_update_membership(org, user, role)
    sync_delete_membership(org, user, role)
    sync_create_membership(org, user)
  end
end
