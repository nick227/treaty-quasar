<template>
  <div class="activity-width">
    <div class="row q-pl-lg q-pr-lg">
      <ActivityCreateWidget :reload="reload" />
      <q-space />
      <h3 class="q-ma-lg text-center" v-if="!items.length && !done">LOADING...</h3>
      <h3 class="q-ma-lg text-center" v-if="!items.length && done">Nothing found.</h3>
      <ActivityCardItem v-for="item in items" :item="item" :key="item.id" />
    </div>
    <div v-if="!done" v-intersection="onIntersection" class="full-width text-center">
      <q-spinner-dots color="primary" size="40px" />
    </div>
  </div>
</template>
<script>
import ActivityCardItem from 'components/activity/ActivityCardItem.vue'
import ActivityCreateWidget from 'components/activity/ActivityCreateWidget.vue'
export default {
  meta () {
    return {
      title: 'Activity'
    }
  },
  name: 'ActivityListPage',
  components: { ActivityCreateWidget, ActivityCardItem },
  data () {
    return {
      items: [],
      pointer: 0,
      limit: 3,
      done: false,
      loadNum: 0
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
      const q = `${process.env.api}/activities?filter[limit]=${this.limit}&filter[skip]=${this.pointer}&filter[include][][relation]=creator&filter[order]=create_date%20DESC`
      const items = await this.$axios.get(q)
      console.log(q)
      if (this.limit > items.data.length) {
        this.done = true
      }
      this.items = this.items.concat(items.data)
      console.log(this.items)
    }
  },
  mounted () {}
}
</script>
