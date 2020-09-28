<template>
  <div>
    <div class="q-ma-none">
      <q-tabs :key="'tabs'+counter" v-model="tab" dense class="q-mb-sm text-grey-7" active-color="primary" indicator-color="purple" align="left">
        <q-tab name="debates" label="Debates" />
        <q-tab name="grievances" :label="'Grievances ' + numGrievances" />
        <q-tab name="offers" :label="'Offers ' + numOffers" />
        <q-tab name="treaties" label="Treaties" />
      </q-tabs>
      <!-- START PANELS -->
      <q-tab-panels v-model="tab" animated transition-prev="fade" transition-next="fade" class="full-width q-pa-none q-mb-lg">
          <!-- grievances panel -->
        <q-tab-panel name="grievances" class="q-pa-none bg-grey-2">
          <ConflictEntitySection :key="'g'+counter" :reload="reloadPanel" :userOrganizationId="user_organization_id" entityType='grievance' :orgA="org_a" :orgB="org_b" :conflictId="conflictId" />
        </q-tab-panel>
          <!-- offers panel -->
        <q-tab-panel name="offers" class="q-pa-none bg-grey-2">
          <ConflictEntitySection :key="'o'+counter" :reload="reloadPanel" :userOrganizationId="user_organization_id" entityType='offer' :orgA="org_a" :orgB="org_b" :conflictId="conflictId" />
        </q-tab-panel>
          <!-- treaties panel -->
        <q-tab-panel name="treaties" class="q-pa-none bg-grey-2">
          <TreatyTableComponent
          :conflictId="conflictId"
          :userOrganizationId="user_organization_id" />
        </q-tab-panel>
          <!-- debates panel -->
        <q-tab-panel name="debates" class="q-pa-none bg-grey-2">
          <DebateTableComponent
          :conflictId="conflictId"
          :userOrganizationId="user_organization_id" />
        </q-tab-panel>
      </q-tab-panels>
      <!-- END PANELS -->
    </div>
    </div>
</template>
<script>
import ConflictEntitySection from 'components/conflict/ConflictEntitySection.vue'
import TreatyTableComponent from 'components/treaty/TreatyTableComponent.vue'
import DebateTableComponent from 'components/debate/DebateTableComponent.vue'
export default {
  name: 'ConflictPanelsSection',
  components: { TreatyTableComponent, DebateTableComponent, ConflictEntitySection },
  props: ['user_organization_id', 'org_a', 'org_b', 'conflictId', 'grievances', 'offers', 'reload'],
  computed: {
    numGrievances: function () {
      return this.grievances[this.org_a.name].length + this.grievances[this.org_b.name].length
    },
    numOffers: function () {
      return this.offers[this.org_a.name].length + this.offers[this.org_b.name].length
    },
    numTreaties: function () {
      return 0
    },
    numDebates: function () {
      return 0
    }
  },
  data () {
    return {
      tab: 'grievances',
      counter: 0
    }
  },
  methods: {
    reloadPanel: async function () {
      await this.reload()
      this.counter++
      console.log('/ske')
    }
  }
}
</script>
