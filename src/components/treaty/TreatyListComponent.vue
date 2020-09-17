<template>
  <div class="row full-width">
    <q-table
    class="full-width align-left table"
    dense
    flat
    :data="treaties"
    :columns="columns"
    row-key="id"
    :pagination="initialPagination"
    >
    <template v-slot:body-cell-actions="props">
          <q-td :props="props">
            <q-btn  square flat color="grey" @click="openTreaty(props)" icon="launch"></q-btn>
          </q-td>
        </template>
    </q-table>
  <q-dialog v-model="showTreaty">
    <TreatyDraft
    :treatyId="childTreatyId"
    :userOrganizationId="childOrganizationId"
    :treatyName="childTreatyName" />
  </q-dialog>z
  </div>
</template>
<script>
import TreatyDraft from 'components/treaty/TreatyDraft.vue'
export default {
  name: 'TreatyListComponent',
  components: { TreatyDraft },
  props: ['userOrganizationId', 'conflictId'],
  data () {
    return {
      treaties: [],
      childTreatyId: null,
      childOrganizationId: null,
      childTreatyName: null,
      pointer: 0,
      limit: 9,
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
    openTreaty: async function (props) {
      this.childTreatyId = props.row.id
      this.childTreatyName = props.row.name
      this.childOrganizationId = props.row.organization_id
      this.showTreaty = true
    },
    getTreaties: async function () {
      const q = `${process.env.api}/treaties?filter[where][conflict_id]=${this.conflictId}&filter[limit]=${this.limit}&filter[skip]=${this.pointer}&filter[include][][relation]=status&filter[include][1][relation]=creator&filter[include][2][relation]=organization&filter[include][3][relation]=votes`
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
