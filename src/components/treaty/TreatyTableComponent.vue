<template>
  <div>
    <q-btn class="full-width text-center" @click="openCreateTreaty" color="accent">Add Treaty</q-btn>
  <div class="row full-width">
    <q-table
    class="full-width align-left table"
    dense
    flat
    @row-click="onRowClick"
    :data="treaties"
    :columns="columns"
    row-key="id"
    :pagination="initialPagination"
    >
      <template v-slot:top-right>
        <q-input borderless dense debounce="300" v-model="filter" placeholder="Search">
          <template v-slot:append>
            <q-icon name="search" />
          </template>
        </q-input>
      </template>
    </q-table>
  <q-dialog v-model="showTreaty" class="z-top">
    <TreatyDialogComponent class="z-top"
    :creatorName="creatorName"
    :creatorId="creatorId"
    :orgAname="orgAname"
    :orgBname="orgBname"
    :userOrganizationId="userOrganizationId"
    :treatyId="childTreatyId" />
  </q-dialog>
  <q-dialog v-model="createTreaty" class="z-top">

  <q-layout view="Lhh lpR fff" container class="bg-white river-width">
    <q-header class="bg-grey">
      <q-toolbar>
        <q-toolbar-title class="text-center">Create Treaty</q-toolbar-title>
        <q-btn flat v-close-popup round dense icon="close" />
      </q-toolbar>
    </q-header>
    <q-page-container>
    <CreateTreaty
    :userOrganizationId="userOrganizationId"
    :conflictId="conflictId"
    :reload="reload" />
  </q-page-container></q-layout>
  </q-dialog>
  </div>
  </div>
</template>
<script>
import TreatyDialogComponent from 'components/treaty/TreatyDialogComponent.vue'
import CreateTreaty from 'components/treaty/CreateTreaty.vue'
import { date } from 'quasar'
export default {
  name: 'TreatyTableComponent',
  components: { TreatyDialogComponent, CreateTreaty },
  props: ['userOrganizationId', 'conflictId', 'orgAname', 'orgBname'],
  data () {
    return {
      filter: '',
      treaties: [],
      childTreatyId: null,
      creatorName: null,
      creatorId: null,
      pointer: 0,
      limit: 9,
      createTreaty: false,
      showTreaty: false,
      done: false,
      loadNum: 0,
      columns: [],
      initialPagination: {
        sortBy: 'desc',
        descending: true,
        page: 1,
        rowsPerPage: 100
      }
    }
  },
  methods: {
    openCreateTreaty: function () {
      if (!this.$errorHandler.organizationCheck(this.userOrganizationId)) { return false }
      this.createTreaty = true
    },
    reload: function () {
      this.treaties = []
      this.createTreaty = false
      this.getTreaties()
    },
    onRowClick: function (e, row) {
      this.openTreaty(row)
    },
    openTreaty: function (row) {
      this.creatorId = row.creatorId
      this.creatorName = row.creatorName
      this.childTreatyId = row.id
      this.showTreaty = true
    },
    getTreaties: async function () {
      const q = `${process.env.api}/treaties?filter[where][conflict_id]=${this.conflictId}&filter[limit]=${this.limit}&filter[skip]=${this.pointer}&filter[include][][relation]=status&filter[include][1][relation]=creator&filter[include][2][relation]=organization&filter[order]=create_date%20DESC`
      const treaties = await this.$axios.get(q)
      if (this.limit > treaties.data.length) {
        this.done = true
      }
      const obj = treaties.data.map((obj) => { return { id: obj.id, avatar_url: obj.avatar_url, create_date: obj.create_date, name: obj.name, description: obj.description, status: obj.status.name, creatorId: obj.creator.id, creatorName: obj.creator.name, organization_id: obj.organization.id, organization: obj.organization.name } })
      this.treaties = this.treaties.concat(obj)
    },
    setupTable: function () {
      this.columns = [
        { name: 'name', label: 'Name', field: 'name', align: 'left' },
        { name: 'organization', label: 'Organization', field: 'organization', sortable: true, align: 'left' },
        { name: 'creatorName', label: 'Creator', field: 'creatorName', sortable: true, align: 'left' },
        { name: 'create_date', label: 'Date', field: 'create_date', sortable: true, align: 'left', format: val => date.formatDate(val, 'M/D/YY') }
      ]
    }
  },
  mounted () {
    this.getTreaties()
    this.setupTable()
  }
}
</script>
