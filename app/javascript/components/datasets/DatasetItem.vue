<template>
  <a :href="`/datasets/${ dataset.path }`"
     class="dataset-card hover:active-dataset-card p-4 sm:w-full border border-gray-200 rounded-xl">
    <div class="flex items-center mb-[5px] w-[399px] sm:w-auto">
      <div class="dataset-path text-sm text-[#303133] font-medium text-ellipsis overflow-hidden whitespace-nowrap">
        {{ getComputed.path }}
      </div>
    </div>
    <p class="h-[40px] w-[399px] sm:w-auto leading-[18px] mb-[5px] text-[#909399] text-xs overflow-hidden overflow-ellipsis line-clamp-2">
      {{ dataset.description }}
    </p>
    <div class="flex items-center gap-[8px] text-xs text-[#909399]">
      <span v-if="getComputed.taskTag">{{ getComputed.taskTag }}</span>
      <span v-if="getComputed.taskTag">
        <svg xmlns="http://www.w3.org/2000/svg" width="1" height="8" viewBox="0 0 1 8" fill="none">
          <path d="M0.5 0V8" stroke="#DCDFE6"/>
        </svg>
      </span>
      <span>{{$t('all.lastTime')}}：{{ dataset.updated_at.substring(0, 10) }}</span>
      <span>
        <svg xmlns="http://www.w3.org/2000/svg" width="1" height="8" viewBox="0 0 1 8" fill="none">
          <path d="M0.5 0V8" stroke="#DCDFE6"/>
        </svg>
      </span>
      <span>{{ getComputed.visibility }}</span>
      <span>
        <svg xmlns="http://www.w3.org/2000/svg" width="1" height="8" viewBox="0 0 1 8" fill="none">
          <path d="M0.5 0V8" stroke="#DCDFE6"/>
        </svg>
      </span>
      <span>{{$t('all.downloadCount')}}：{{ dataset.downloads }}</span>
    </div>
  </a>
</template>

<script setup>
  import { computed } from 'vue'
  import { useI18n } from 'vue-i18n'

  const props = defineProps({
    dataset: Object,
  })

  const { t } = useI18n();

  const getComputed = computed(() => {
    const displayName = props.dataset.nickname !== undefined && props.dataset.nickname.trim().length > 0 ? props.dataset.nickname : props.dataset.name
    const path = props.dataset.path.split('/')[0] + '/' + displayName

    const visibility = props.dataset.private ? t('all.private')  : t('all.public')

    let taskTag = (props.dataset.tags || []).find(tag => tag.category === "task")
    taskTag = taskTag? taskTag["show_name"] : null
    return { path: path, visibility: visibility, taskTag: taskTag }
  })
</script>

<style scoped>
  .dataset-card:hover .dataset-path {
    color: var(--blue-blue-5001-f-75-cb, #1F75CB);
  }
</style>
