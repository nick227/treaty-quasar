<template>
  <q-layout view="Lhh lpR fff" style="width:1250px; max-width:99%;" container class="bg-white">
    <q-header class="bg-primary">
      <q-toolbar>
        <q-toolbar-title class="q-pl-lg">{{ treatyName }}</q-toolbar-title>
        <q-btn flat v-close-popup round dense icon="close" />
      </q-toolbar>
    </q-header>
     <q-page-container>
     <q-page padding>
    <q-expansion-item v-model="expanded" label="Add Provision" class="full-width q-mb-sm bg-grey-11">
      <AddProvision
      :treatyId="treatyId"
      :numProvisions="numProvisions"
      :reload="loadProvisions" />
    </q-expansion-item>
    <q-list class="full-width">
      <div v-for="(provision, index) in provisions" :key="provision.id" class="full-width q-mb-sm">
        <div class="row q-mb-sm">
          <div class="col text-center">
            <h4 class="border text-center q-pa-lg bg-grey-11 full-width">{{ index + 1 }}</h4>
          </div>
          <div class="col col-10 text-left q-pl-md">
            <h6 class="q-pb-none">{{ provision.title }}</h6>
            <p class="q-pa-none">{{ provision.description }}</p>
          </div>
          <div class="col text-center q-pt-lg">
            <LikeButtons
            :key="likeKey"
            entityType='provision'
            :entityId="provision.id"
            :organizationId="userOrganizationId" />
          </div>
        </div>
    <CommentsWidget
          :entityId="provision.id"
          entityType="provision"
    ></CommentsWidget>
      </div>
    </q-list>
    <VoteTreatyWidget
    :id="treatyId"
    :userOrganizationId="userOrganizationId" />
          </q-page>
        </q-page-container>
  </q-layout>
</template>
<script>
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import AddProvision from 'components/treaty/AddProvision.vue'
import VoteTreatyWidget from 'components/treaty/VoteTreatyWidget.vue'
import LikeButtons from 'components/widgets/LikeButtonsWidget.vue'
export default {
  name: 'TreatyDraft',
  props: ['treatyId', 'userOrganizationId', 'treatyName'],
  components: { AddProvision, LikeButtons, CommentsWidget, VoteTreatyWidget },
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
