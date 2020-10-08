<template>
  <div :class="!entityId ? 'river-width' : 'full-width'">
  <div class="q-mt-lg">
    <h6 class="q-mb-sm text-center" v-if="!entityId">Activity</h6>
    <q-separator v-if="!entityId" class="q-mb-lg" />
    <div class="row">
      <ActivityCreateWidget class="q-pb-lg q-mb-lg" :reload="reload" :entityType="entityType" :entityId="entityId" />
      <q-space /><q-space />
      <h5 class="q-ma-lg text-center" v-if="!items.length && !done">LOADING...</h5>
      <h5 class="q-ma-lg text-center" v-if="!items.length && done">Nothing found.</h5>
      <ActivityCardItem v-for="item in items" :entityId="entityId" :entityType="entityType" :item="item" :reload="reload" :key="item.id" />
    </div>
    <div v-if="!done" v-intersection="onIntersection" class="full-width text-center">
      <q-spinner-dots color="primary" size="40px" />
    </div>
  </div>
  </div>
</template>
<script>
import ActivityCardItem from 'components/activity/ActivityCardItem.vue'
import ActivityCreateWidget from 'components/activity/ActivityCreateWidget.vue'
export default {
  meta () {
    return {
      title: typeof this.title === 'string' ? this.title : 'Activity'
    }
  },
  name: 'ActivityListPage',
  components: { ActivityCreateWidget, ActivityCardItem },
  props: ['entityId', 'entityType', 'title'],
  data () {
    return {
      items: [],
      pointer: 0,
      limit: 3,
      done: false,
      loadNum: 0,
      expanded: false
    }
  },
  created () {
    this.getItems()
  },
  methods: {
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.getItems()
      }
      this.loadNum++
    },
    reload: function () {
      this.pointer = 0
      this.done = false
      this.items = []
      this.getItems()
    },
    getItems: async function () {
      let q = `${process.env.api}/activities?filter[limit]=${this.limit}&filter[skip]=${this.pointer}&filter[include][0][relation]=creator&filter[include][1][relation]=emotions&filter[order]=create_date%20DESC`
      q += typeof this.entityType === 'string' ? `&filter[where][and][2][entity_type]=${this.entityType}` : ''
      q += typeof this.entityId === 'number' ? `&filter[where][and][3][entity_id]=${this.entityId}` : ''
      const items = await this.$axios.get(q)
      if (this.limit > items.data.length) {
        this.done = true
      }
      this.items = this.items.concat(items.data)
    }
  },
  mounted () {}
}
</script>
