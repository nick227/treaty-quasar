<template>
  <q-page padding>
  <q-expansion-item switch-toggle-side dense-toggle label="Create Treaty">
    <CreateTreatyWidget />
  </q-expansion-item>
    <q-list padding>
      <q-separator />
    <div v-for="treaty in treaties" :key="treaty.id">
      <q-item>
         <q-item-section top avatar>
          <q-item class="q-mr-md" tag="a" :to="'/treaty/'+treaty.id"><q-avatar size="240px" square class=""><q-img rounded class="q-mt-none" :src="treaty.avatar_url"></q-img></q-avatar></q-item>
        </q-item-section>
        <q-item-section>
          <q-item class="q-pa-sm" tag="a" :to="'/treaty/'+treaty.id"><q-item-label>{{ treaty.name }}</q-item-label></q-item>
          <q-item-label class="q-pa-sm" caption lines="2">{{ treaty.description }}</q-item-label>
        </q-item-section>
      </q-item>
      <q-separator />
    </div>
  </q-list>
  </q-page>
</template>
<script>
import CreateTreatyWidget from 'components/CreateTreatyWidget.vue'
export default {
  components: { CreateTreatyWidget },
  name: 'TreatyList',
  data () {
    return {
      treaties: []
    }
  },
  async created () {
    this.reload()
  },
  methods: {
    reload: function () {
      this.loadTreaties()
    },
    loadTreaties: async function () {
      const q = 'http://localhost:3000/treaties?filter[order]=create_date%20DESC'
      const treaties = await this.$axios.get(q)
      this.treaties = treaties.data
    }
  }
}

</script>
