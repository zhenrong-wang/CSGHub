module Starhub
  module DatasetApis
    def get_dataset_detail_data_in_parallel(namespace, dataset_name, options = {})
      get_repo_detail_data_in_parallel('datasets', namespace, dataset_name, options)
    end

    def get_dataset_detail_files_data_in_parallel(namespace, dataset_name, options = {})
      get_repo_detail_files_data_in_parallel('datasets', namespace, dataset_name, options)
    end

    def get_dataset_detail_blob_data_in_parallel(namespace, dataset_name, options = {})
      get_repo_detail_blob_data_in_parallel('datasets', namespace, dataset_name, options)
    end

    def get_datasets(current_user, keyword, sort_by, task_tag, framework_tag, license_tag, page = 1, per = 16)
      get_repos('datasets', current_user, keyword, sort_by, task_tag, framework_tag, license_tag, page, per)
    end

    def get_dataset_detail(namespace, dataset_name, options = {})
      get_repo_detail('datasets', namespace, dataset_name, options)
    end

    def get_dataset_files(namespace, dataset_name, options = {})
      get_repo_files('datasets', namespace, dataset_name, options)
    end

    def get_dataset_last_commit(namespace, dataset_name, options = {})
      get_repo_last_commit('datasets', namespace, dataset_name, options)
    end

    def get_dataset_branches(namespace, dataset_name, options = {})
      get_repo_branches('datasets', namespace, dataset_name, options)
    end

    def get_dataset_file_content(namespace, dataset_name, path, options = {}) get_repo_file_content('datasets', namespace, dataset_name, path, options)
    end

    def create_dataset(username, dataset_name, namespace, nickname, desc, options = {})
      create_repo('datasets', username, dataset_name, namespace, nickname, desc, options)
    end

    def delete_dataset(namespace, dataset_name, params = {})
      delete_repo('datasets', namespace, dataset_name, params)
    end

    def update_dataset(username, dataset_name, namespace, nickname, desc, options = {})
      update_repo('datasets', username, dataset_name, namespace, nickname, desc, options)
    end

    def get_dataset_tags(namespace, dataset_name, options = {})
      get_repo_tags('datasets', namespace, dataset_name, options)
    end

    def download_dataset_file(namespace, dataset_name, path, options = {})
      download_repo_file('datasets', namespace, dataset_name, path, options)
    end

    def download_dataset_resolve_file(namespace, dataset_name, path, options = {})
      download_repo_resolve_file('datasets', namespace, dataset_name, path, options)
    end

    def create_dataset_file(namespace, dataset_name, path, options = {})
      create_repo_file('datasets', namespace, dataset_name, path, options)
    end

    def update_dataset_file(namespace, dataset_name, path, options = {})
      update_repo_file('datasets', namespace, dataset_name, path, options)
    end

    def upload_dataset_file(namespace, dataset_name, options = {})
      upload_repo_file('datasets', namespace, dataset_name, options)
    end
  end
end
