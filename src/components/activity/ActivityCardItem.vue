<template>
  <div class="full-width q-pa-lg">
    <q-card class="q-pl-lg q-pr-lg q-pb-lg">
      <q-card-section side class="q-pb-md text-center">
        <div class="q-pb-none">{{ item.creator.name }}</div>
        <q-avatar round size="40px" class=""><img :src="item.creator.avatar_url" /></q-avatar>
      </q-card-section>
      <q-card-section side class="q-pa-none text-center">
        <div class="q-pb-lg" v-html="readyMessage"></div>
      </q-card-section>
    </q-card>
    <CommentsWidget
          :entityId="item.id"
          entityType="activity"
    ></CommentsWidget>
  </div>
</template>
<script>
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import TextToolsMixin from 'components/mixins/TextToolsMixin.vue'
export default {
  name: 'ActivityCardItem',
  mixins: [TextToolsMixin],
  components: { CommentsWidget },
  props: ['item'],
  data () {
    return {}
  },
  computed: {
    readyMessage: function () {
      return this.checkStr(this.item.message)
    }
  },
  mounted () {}
}
</script>
