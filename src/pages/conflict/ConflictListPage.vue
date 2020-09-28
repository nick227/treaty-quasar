<template>
  <q-page padding class="river-width">
    <q-expansion-item @before-show="userCheck" v-model="expanded" switch-toggle-side dense-toggle label="Create Conflict">
      <CreateConflictWidget />
    </q-expansion-item>
    <h6 class="q-mb-sm text-center">Conflicts</h6>
      <q-separator />
    <q-list class="row">
      <h3 class="q-ma-lg text-center" v-if="!conflicts.length && !done">LOADING...</h3>
      <h3 class="q-ma-lg text-center" v-if="!conflicts.length && done">No conflicts found.</h3>
      <div v-for="conflict in conflicts" class="col col-shrink info-card q-mb-lg" :key="conflict.id">
        <q-card class="flex-break q-ma-lg">
          <div :style="'background-image:url(' + conflict.avatar_url + ')'" class="card-image"></div>
          <q-card-section>
            <p>{{ conflict.organization_a.name }} vs. {{ conflict.organization_b.name }}</p>
            <div clickable class="text-h6 cursor-pointer">{{ conflict.name }}</div>
            <p class="ellipsis">{{ conflict.description }}</p>
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
