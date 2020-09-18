<template>
  <q-page padding class="river-column">
  <q-expansion-item switch-toggle-side dense-toggle label="Create Treaty">
    ok
  </q-expansion-item>
    <q-list padding>
      <q-separator />
    <div v-for="treaty in treaties" :key="treaty.id">
          <div class="row q-pl-md q-pr-md" style="">
            <div class="col col-5"><h6>org a</h6></div>
            <div class="col col-2 text-center"><h6>vs.</h6></div>
            <div class="col col-5 text-right"><h6>org b</h6></div>
          </div>
      <q-item class="full-width" tag="a" :to="'/treaty/'+treaty.id">
         <q-card class="full-width">
      <q-img rounded class="q-mt-none" :src="treaty.avatar_url"></q-img>
      <q-card-section>
        <div class="text-h6">{{ treaty.name }}</div>
      </q-card-section>
      <q-card-section class="q-pt-none">
        {{ treaty.description }}
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
export default {
  meta () {
    return {
      title: 'Treaties'
    }
  },
  name: 'ListTreatyPage',
  components: {},
  data () {
    return {
      treaties: [],
      pointer: 0,
      limit: 2,
      done: false,
      loadNum: 0
    }
  },
  methods: {
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.loadtreaties()
      }
      this.loadNum++
    },
    loadTreaties: async function () {
      const q = `${process.env.api}/treaties?filter[order]=create_date%20DESC&filter[limit]=${this.limit}&filter[skip]=${this.pointer}`
      const treaties = await this.$axios.get(q)
      if (this.limit > treaties.data.length) {
        this.done = true
      }
      this.treaties = this.treaties.concat(treaties.data)
    }
  },
  async created () {
    this.loadTreaties()
  },
  mounted () {}
}
</script>
