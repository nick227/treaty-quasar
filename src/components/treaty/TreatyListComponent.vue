<template>
  <div>
  <div class="full-width q-pa-sm q-mb-lg">
    <q-btn class="full-width" @click="createTreaty = true" color="primary">Create Treaty</q-btn>
  </div>
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
    <template v-slot:body-cell-actions="props">
          <q-td :props="props">
            <q-btn  square flat color="grey" @click="openTreaty(props.row)" icon="launch"></q-btn>
          </q-td>
        </template>
    </q-table>
  <q-dialog class="z-top" v-model="showTreaty">
    <TreatyDraft
    :treatyId="childTreatyId"
    :userOrganizationId="childOrganizationId"
    :treatyName="childTreatyName" />
  </q-dialog>
  <q-dialog v-model="createTreaty">
    <CreateTreaty
    :userOrganizationId="userOrganizationId"
    :conflictId="conflictId"
    :reset="reset" />
  </q-dialog>
  </div>
  </div>
</template>
<script>
import TreatyDraft from 'components/treaty/TreatyDraft.vue'
import CreateTreaty from 'components/treaty/CreateTreaty.vue'
export default {
  name: 'TreatyListComponent',
  components: { TreatyDraft, CreateTreaty },
  props: ['userOrganizationId', 'conflictId'],
  data () {
    return {
      treaties: [],
      childTreatyId: null,
      childOrganizationId: null,
      childTreatyName: null,
      pointer: 0,
      limit: 9,
      createTreaty: false,
      showTreaty: false,
      done: false,
      loadNum: 0,
      columns: [],
      initialPagination: {
        sortBy: 'desc',
        descending: false,
        page: 1,
        rowsPerPage: 10
      }
    }
  },
  methods: {
    reset: function () {
      this.createTreaty = false
      this.getTreaties()
    },
    onRowClick: function (e, row) {
      this.openTreaty(row)
    },
    openTreaty: function (row) {
      this.childTreatyId = row.id
      this.childTreatyName = row.name
      this.childOrganizationId = row.organization_id
      this.showTreaty = true
    },
    getTreaties: async function () {
      const q = `${process.env.api}/treaties?filter[where][conflict_id]=${this.conflictId}&filter[limit]=${this.limit}&filter[skip]=${this.pointer}&filter[include][][relation]=status&filter[include][1][relation]=creator&filter[include][2][relation]=organization&filter[order]=create_date%20DESC`
      const treaties = await this.$axios.get(q)
      if (this.limit > treaties.data.length) {
        this.done = true
      }
      const obj = treaties.data.map((obj) => { return { id: obj.id, name: obj.name, description: obj.description, status: obj.status.name, creator: obj.creator.name, organization_id: obj.organization.id, organization: obj.organization.name } })
      this.treaties = this.treaties.concat(obj)
    },
    setupTable: function () {
      this.columns = [
        { name: 'name', label: 'Name', field: 'name', align: 'left' },
        { name: 'description', label: 'Description', field: 'description', sortable: true, align: 'left' },
        { name: 'status', label: 'Status', field: 'status', sortable: true, align: 'left' },
        { name: 'organization', label: 'Organization', field: 'organization', sortable: true, align: 'left' },
        { name: 'creator', label: 'Creator', field: 'creator', sortable: true, align: 'left' },
        { name: 'actions', label: 'View', field: '', align: 'center' }
      ]
    }
  },
  mounted () {
    this.getTreaties()
    this.setupTable()
  }
}
</script>
