<template>
  <div>
    <div class="q-ma-none">
      <q-tabs :key="'tabs'+counter" v-model="tab" dense class="q-mb-sm text-grey-7 bg-grey-4" active-color="black" indicator-color="purple" align="left">
        <q-tab name="activity" :label="'Activity ' + numActivity" />
        <q-tab name="topics" :label="'Topics ' + numTopics" />
        <q-tab name="grievances" :label="'Grievances ' + numGrievances" />
        <q-tab name="offers" :label="'Offers ' + numOffers" />
        <q-tab name="treaties" :label="'Treaties ' + numTreaties" />
      </q-tabs>
      <!-- START PANELS -->
      <q-tab-panels v-model="tab" animated transition-prev="fade" transition-next="fade" class="full-width q-pa-none q-mb-none">
          <!-- grievances panel -->
        <q-tab-panel name="grievances" class="q-pa-none bg-grey-2">
          <p class="q-pa-md q-ma-none">List your organization's grievances or issues with the opposing group here. Please limit each grievance to one entry each. Be as specific and direct as possible. Comment on grievances and rate the importance by voting thumbs up or down on each entry.</p>
          <ConflictEntitySection :key="'g'+counter" :reload="reloadPanel" :userOrganizationId="userOrganizationId" entityType='grievance' :orgA="orgA" :orgB="orgB" :conflictId="conflictId" />
        </q-tab-panel>
          <!-- offers panel -->
        <q-tab-panel name="offers" class="q-pa-none bg-grey-2">
          <p class="q-pa-md q-ma-none">List offers or concessions you think your organization should make here. Please limit each offer to one entry each. Be as specific and direct as possible. Comment on offers and rate the importance by voting thumbs up or down on each entry.</p>
          <ConflictEntitySection :key="'o'+counter" :reload="reloadPanel" :userOrganizationId="userOrganizationId" entityType='offer' :orgA="orgA" :orgB="orgB" :conflictId="conflictId" /> </q-tab-panel>
          <!-- treaties panel -->
        <q-tab-panel name="treaties" class="q-pa-none bg-grey-2">
          <p class="q-pa-md q-ma-none">Treaties are the ultimate purpose of this website. Every treaty consists of provisions. These are points that all parties are willing to agree to which bring both organizations closer to the goal of reconciliation. Click the row to open treaty.</p>
          <TreatyTableComponent
          :conflictId="conflictId"
          :orgAname= "orgA.name"
          :orgBname= "orgB.name"
          :userOrganizationId="userOrganizationId" />
        </q-tab-panel>
          <!-- topics panel -->
        <q-tab-panel name="topics" class="q-pa-none bg-grey-2">
          <p class="q-pa-md q-ma-none">Create a new topic to discuss here. Comment on existing topics, share your thoughts and ideas. Please be civil and keep all comments relevant to this conflict between {{ orgA.name }} and {{ orgB.name }}. Keep each entry specific and direct. Click on row to open conversation.</p>
          <DebateTableComponent
          :conflictId="conflictId"
          :userOrganizationId="userOrganizationId" />
        </q-tab-panel>
          <!-- activity panel -->
        <q-tab-panel name="activity" class="q-pa-none">
          <ActivityListPage
          :title="title"
          entityType="conflict"
          :entityId="conflictId" />
        </q-tab-panel>
      </q-tab-panels>
      <!-- END PANELS -->
    </div>
    </div>
</template>
<script>
import ActivityListPage from 'pages/activity/ActivityListPage.vue'
import ConflictEntitySection from 'components/conflict/ConflictEntitySection.vue'
import TreatyTableComponent from 'components/treaty/TreatyTableComponent.vue'
import DebateTableComponent from 'components/debate/DebateTableComponent.vue'
export default {
  name: 'ConflictPanelsSection',
  components: { TreatyTableComponent, DebateTableComponent, ConflictEntitySection, ActivityListPage },
  props: ['userOrganizationId', 'orgA', 'orgB', 'conflictId', 'reload', 'title'],
  data () {
    return {
      tab: 'activity',
      counter: 0,
      numTreaties: 0,
      numGrievances: 0,
      numOffers: 0,
      numTopics: 0,
      numActivity: 0
    }
  },
  mounted () {
    this.getNums()
  },
  methods: {
    getNums: async function () {
      let q = ''
      let res = {}
      let o = {}
      const objs = [{ key: 'treaties', varName: 'numTreaties' }, { key: 'debates', varName: 'numTopics' }, { key: 'grievances', varName: 'numGrievances' }, { key: 'offers', varName: 'numOffers' }]
      for (let i = 0; i < objs.length; i++) {
        o = objs[i]
        q = `${process.env.api}/${o.key}/count?where[conflict_id]=${this.conflictId}`
        res = await this.$axios.get(q)
        this[o.varName] = res.data.count
      }
      q = `${process.env.api}/activities/count?[where][and][0][entity_type]=conflict&[where][and][1][entity_id]=${this.conflictId}`
      console.log(q)
      res = await this.$axios.get(q)
      console.log(res)
      this.numActivity = res.data.count
    },
    reloadPanel: async function () {
      await this.getNums()
      this.counter++
    }
  }
}
</script>
