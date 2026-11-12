<template>
  <el-tag v-for="(t, i) in tags"
          :key="t.name"
          class="tag"
          :closable="t.closeable"
          @close="close(t)"
          @click="toTag(t)"
          :type="t.active?'primary':'info'"
          :effect="t.active?'dark':'plain'">
    {{ T(t.title) }}
  </el-tag>
</template>

<script>
  import { defineComponent, ref, onMounted, watch, nextTick } from 'vue'
  import { useTagsStore } from '@/store/tags'
  import { useRoute, useRouter } from 'vue-router'
  import { T } from '@/utils/i18n'

  export default defineComponent({
    name: 'Index',
    setup () {
      const tags = ref([])
      const tagsStore = useTagsStore()
      const route = useRoute()
      const router = useRouter()
      tags.value = tagsStore.tags

      const addTag = (route) => {
        if (!route.meta?.hide && route.name) {
          tagsStore.addTag(route)
        }
      }
      const close = (tag) => {
        tagsStore.removeTag(tag)
        if (tag.active) {
          toLastTag()
        }
      }
      const toLastTag = () => {
        if (tags.value.length) {
          router.push({ name: tags.value[tags.value.length - 1].name })
        }
      }
      const init = () => {
        if (!tagsStore.tags.length) {
          tagsStore.initTags()
        }
        addTag(route)
      }

      const toTag = (tag) => {
        if (tag.name !== route.name) {
          router.push({ name: tag.name })
        }
      }

      // Keep the active tab visible when the bar is scrolled.
      const showActiveTag = () => {
        nextTick(() => {
          const el = document.querySelector('.header-tags .el-tag--dark')
          if (el) {
            el.scrollIntoView({ block: 'nearest', inline: 'nearest' })
          }
        })
      }

      onMounted(() => {
        init()
        showActiveTag()
      })
      watch(route, (val) => {
        addTag(val)
        showActiveTag()
      })
      return {
        tags,
        addTag,
        close,
        toLastTag,
        toTag,
        T,
      }
    },
  })
</script>

<style lang="scss" scoped>

.tag {
  border-radius: 0;
  cursor: pointer;

  &.active {
  }
}
</style>
