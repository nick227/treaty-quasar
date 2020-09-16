<template>
  <div class="row full-width">
    <q-expansion-item v-model="expanded" label="Add Provision" class="full-width q-mb-lg bg-grey-11">
      <AddProvision
      :treatyId="treatyId"
      :numProvisions="numProvisions"
      :reload="loadProvisions" />
    </q-expansion-item>
    <q-list class="full-width">
      <div v-for="(provision, index) in provisions" :key="provision.id" class="full-width">
        <div class="row">
          <div class="col text-center">
            <h4 class="border q-pa-lg float-left bg-grey-11 full-width">{{ index + 1 }}</h4>
          </div>
          <div class="col col-11 text-left q-pl-md">
            <h5 class="q-pb-none">{{ provision.title }}</h5>
            <p>{{ provision.description }}</p>
          </div>
          <div class="col text-center">
            <LikeButtons
            :key="likeKey"
            entityType='provision'
            :entityId="provision.id"
            :organizationId="userOrganizationId" />
          </div>
        </div>
        <q-separator />
      </div>
    </q-list>
  </div>
</template>
<script>
import AddProvision from 'components/treaty/AddProvision.vue'
import LikeButtons from 'components/widgets/LikeButtonsWidget.vue'
export default {
  name: 'TreatyDraft',
  props: ['treatyId', 'userOrganizationId'],
  components: { AddProvision, LikeButtons },
  data () {
    return {
      likeKey: 0,
      expanded: false,
      provisions: [],
      columns: [],
      numProvisions: 0,
      initialPagination: {
        sortBy: 'desc',
        descending: false,
        page: 1,
        rowsPerPage: 10
      }
    }
  },
  watch: {
    userOrganizationId: function () {
      this.likeKey++
    }
  },
  methods: {
    setupTable: function () {
      this.columns = [
        { name: 'position', align: 'left', label: 'Position', field: 'position', sortable: true, style: 'width:55px;' },
        { name: 'title', align: 'left', label: 'Title', field: 'title', sortable: true },
        { name: 'description', align: 'left', label: 'Description', field: 'description', sortable: true }
      ]
    },
    loadProvisions: async function () {
      const q = `${process.env.api}/treaty-provisions?filter[where][treaty_id]=${this.treatyId}&filter[order]=position%20ASC`
      const provisions = await this.$axios.get(q)
      this.provisions = provisions.data
      this.numProvisions = this.provisions.length ? this.provisions.length : 0
    }
  },
  created () {
    this.loadProvisions()
    this.setupTable()
  }
}
</script>
