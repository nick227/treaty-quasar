<template>
  <div>
      <q-expansion-item @before-show="userCheck" v-model="expanded" switch-toggle-side dense-toggle label="Add Topic">
        <CreateDebateWidget :conflictId="conflictId" :userOrganizationId="userOrganizationId" :reload="reload" />
      </q-expansion-item>
  <div class="row full-width">
    <q-table
    style=""
    class="full-width align-left table q-pa-sm"
    dense
    flat
    @row-click="onRowClick"
    :loading="loading"
    :data="readyDebates"
    :columns="columns"
    row-key="id"
    :pagination="initialPagination"
    >
    <template v-slot:body-cell-actions="props">
          <q-td :props="props">
            <q-btn  square flat color="grey" @click="openDebate(props.row)" icon="launch"></q-btn>
          </q-td>
        </template>
    </q-table>
  </div>

  <q-dialog v-model="showDebate" class="z-top">
    <DebateDialogComponent class="z-top"
    :userOrganizationId="userOrganizationId"
    :debateId="childDebateId" />
  </q-dialog>
  </div>
</template>
<script>
import DebateDialogComponent from 'components/debate/DebateDialogComponent.vue'
import CreateDebateWidget from 'components/debate/CreateDebateWidget.vue'
export default {
  name: 'DebateTableComponent',
  props: ['userOrganizationId', 'conflictId'],
  components: { CreateDebateWidget, DebateDialogComponent },
  data () {
    return {
      expanded: false,
      childDebateId: null,
      debates: [],
      pointer: 0,
      limit: 5,
      done: false,
      loading: false,
      loadNum: 0,
      columns: [],
      showDebate: false,
      initialPagination: {
        sortBy: 'desc',
        descending: true,
        page: 1,
        rowsPerPage: 100
      }
    }
  },
  mounted () {},
  async created () {
    this.loadDebates()
    this.setupTable()
  },
  computed: {
    readyDebates: function () {
      return this.debates.map((obj) => {
        obj.creator_name = obj.creator.name
        obj.creator_avatar_url = obj.creator.avatar_url
        obj.creator_organization_name = obj.organization.name
        return obj
      })
    }
  },
  methods: {
    userCheck (e) {
      if (!this.$errorHandler.organizationCheck(this.userOrganizationId)) { this.expanded = false }
    },
    truncate: function (str) {
      const max = 8
      return str.length > max ? str.slice(0, max) + '...' : str
    },
    setupTable: function () {
      this.columns = [
        { name: 'title', label: 'Title', field: 'title', align: 'left', classes: 'ellipsis' },
        { name: 'description', label: 'Description', field: 'description', sortable: true, align: 'left', classes: 'ellipsis', format: (val) => { return val.length > 50 ? val.slice(0, 50) + '...' : val } },
        { name: 'creator', label: 'Created by', field: 'creator_name', sortable: true, align: 'left' },
        { name: 'creator_organization', label: 'Organization', field: 'creator_organization_name', sortable: true, align: 'left' },
        { name: 'actions', label: 'View', field: '', align: 'center' }
      ]
    },
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.loadDebates()
      }
      this.loadNum++
    },
    onRowClick: function (e, row) {
      this.openDebate(row)
    },
    openDebate: function (row) {
      this.childDebateId = row.id
      this.showDebate = true
    },
    loadDebates: async function () {
      const q = `${process.env.api}/debates?filter[where][conflict_id]=${this.conflictId}&filter[include][0][relation]=organization&filter[include][1][relation]=creator&filter[order]=create_date%20DESC&filter[limit]=${this.limit}&filter[skip]=${this.pointer}`
      const debates = await this.$axios.get(q)
      if (this.limit > debates.data.length) {
        this.done = true
      }
      this.debates = this.debates.concat(debates.data)
    },
    reload: function () {
      this.new_debate = false
      this.debates = []
      this.loadDebates()
    }
  }
}
</script>
