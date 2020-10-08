<template>
  <q-page padding class="river-width">
    <q-expansion-item @before-show="userCheck" v-model="expanded" switch-toggle-side dense-toggle label="Create Conflict">
      <CreateConflictWidget />
    </q-expansion-item>
    <h6 class="q-mb-sm text-center">Conflicts</h6>
      <q-separator />
    <q-list class="row">
      <h5 class="q-ma-lg text-center" v-if="!conflicts.length && !done">LOADING...</h5>
      <h5 class="q-ma-lg text-center" v-if="!conflicts.length && done">No conflicts found.</h5>
      <div v-for="conflict in conflicts" class="col col-shrink info-card q-mb-lg" :key="conflict.id">
        <q-card class="flex-break q-ma-lg">
          <router-link :to="'/conflict/'+conflict.id"><div :style="'background-image:url(' + conflict.avatar_url + ')'" class="card-image"></div></router-link>
          <q-card-section>
            <div clickable class="text-h6 cursor-pointer ellipsis">{{ conflict.name }}</div>
            <p class="ellipsis q-ma-none q-pa-none q-pb-sm">{{ conflict.description }}</p>
            <p class="q-ma-none q-pa-none ellipsis"><span class="">{{ conflict.organization_a.name }}</span> vs. <span class="">{{ conflict.organization_b.name }}</span></p>
          </q-card-section>
    <q-card-section>
      <router-link :to="'/conflict/'+conflict.id"><q-btn class="full-width" color="primary" label="Visit" /></router-link>
    </q-card-section>
        </q-card>
      </div>
      <div v-if="!done" v-intersection="onIntersection" class="full-width text-center">
        <q-spinner-dots color="primary" size="40px" />
      </div>
    </q-list>
  </q-page>
</template>
<script>
import CreateConflictWidget from 'components/conflict/CreateConflictWidget.vue'
export default {
  meta () {
    return {
      title: 'Conflicts'
    }
  },
  components: { CreateConflictWidget },
  name: 'ConflictList',
  data () {
    return {
      conflicts: [],
      pointer: 0,
      limit: 10,
      done: false,
      loadNum: 0,
      expanded: false
    }
  },
  async created () {
    this.loadConflicts()
  },
  methods: {
    userCheck (e) {
      if (!this.$errorHandler.loggedInCheck()) { this.expanded = false }
    },
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.loadConflicts()
      }
      this.loadNum++
    },
    loadConflicts: async function () {
      const q = `${process.env.api}/conflicts?filter[include][0][relation]=organization_a&filter[include][1][relation]=organization_b&filter[order]=create_date%20DESC&filter[limit]=${this.limit}&filter[skip]=${this.pointer}`
      const conflicts = await this.$axios.get(q)
      if (this.limit > conflicts.data.length) {
        this.done = true
      }
      this.conflicts = this.conflicts.concat(conflicts.data)
      console.log(this.conflicts[0])
    }
  }
}

</script>
