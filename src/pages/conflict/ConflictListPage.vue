<template>
  <q-page padding class="river-width">
  <q-expansion-item switch-toggle-side dense-toggle label="Create Conflict">
    <CreateConflictWidget />
  </q-expansion-item>
    <q-list padding>
      <q-separator />
    <div v-for="conflict in conflicts" :key="conflict.id">
          <div class="row q-pl-md q-pr-md" style="">
            <div class="col col-5"><h6>{{ conflict.organization_a.name }}</h6></div>
            <div class="col col-2 text-center"><h6>vs.</h6></div>
            <div class="col col-5 text-right"><h6>{{ conflict.organization_b.name }}</h6></div>
          </div>
      <q-item class="full-width" tag="a" :to="'/conflict/'+conflict.id">
         <q-card class="full-width">
      <q-img rounded class="q-mt-none" :src="conflict.avatar_url"></q-img>
      <q-card-section>
        <div class="text-h6">{{ conflict.name }}</div>
      </q-card-section>
      <q-card-section class="q-pt-none">
        {{ conflict.description }}
      </q-card-section>
    </q-card>
      </q-item>
      <q-separator />
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
      limit: 2,
      done: false,
      loadNum: 0
    }
  },
  async created () {
    this.loadConflicts()
  },
  methods: {
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
    }
  }
}

</script>
