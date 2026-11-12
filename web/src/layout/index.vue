<template>
  <el-config-provider :locale="appStore.setting.locale.value">
    <el-container :style="{'--sideBarWidth': sideBarWidth}">
      <el-aside :width="leftWidth" class="app-left">
        <g-aside></g-aside>
      </el-aside>
      <el-container class="app-container ">
        <el-header class="app-header">
          <g-header></g-header>
        </el-header>
        <div class="header-tags">
          <tags></tags>
        </div>

        <el-main class="app-main">
          <router-view v-slot="{ Component }">
            <transition mode="out-in" name="el-fade-in-linear">
              <keep-alive :include="cachedTags">
                <component :is="Component"/>
              </keep-alive>
            </transition>
          </router-view>
        </el-main>
      </el-container>
    </el-container>
  </el-config-provider>
</template>

<script setup>
  import { useAppStore } from '@/store/app'
  import { useTagsStore } from '@/store/tags'
  import { ref, computed } from 'vue'
  import Tags from '@/layout/components/tags/index.vue'
  import GAside from '@/layout/components/aside.vue'
  import GHeader from '@/layout/components/header.vue'

  const appStore = useAppStore()
  const tagStore = useTagsStore()
  const sideBarWidth = computed(() => appStore.setting.locale.sideBarWidth)
  const leftWidth = computed(() => appStore.setting.sideIsCollapse ? '64px' : 'var(--sideBarWidth)')

  const cachedTags = ref([])

  cachedTags.value = tagStore.cached
</script>

<style lang="scss" scoped>
.app-header {
  background-color: #3f454b;
  color: var(--basicWhite);
  display: flex;
  height: 50px;
}

.header-tags {
  height: auto;
  border-bottom: 1px solid #eee;
  display: flex;
  flex-wrap: nowrap;
  padding: 0;
  /* Many open tabs scroll inside the bar instead of widening the page. */
  overflow-x: auto;
  overflow-y: hidden;
  scrollbar-width: thin;

  :deep(.el-tag) {
    flex: 0 0 auto;
  }
}

.app-left {
  transition: width 0.5s;
}

.app-container {
  min-height: 100vh;
  /* Let this column shrink to the window; without it wide content pushes
     the header and page past the right edge. */
  min-width: 0;
}
</style>


