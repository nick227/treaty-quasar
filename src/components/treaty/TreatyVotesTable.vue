<template>
  <div class="row full-width">
    <q-table
    class="full-width align-left table q-pa-sm"
    title=""
    dense
    flat
    :data="votes"
    :filter="filter"
    :columns="columns"
    row-key="id"
    :pagination="initialPagination"
    :columns_filter="true"
    >
      <template v-slot:top-right>
        <q-input borderless dense debounce="300" v-model="filter" placeholder="Search">
          <template v-slot:append>
            <q-icon name="search" />
          </template>
        </q-input>
      </template>
    </q-table>
  </div>
</template>
<script>
import { date } from 'quasar'
export default {
  name: 'TreatyVotesTable',
  props: ['votes', 'id'],
  data () {
    return {
      filter: '',
      columns: [],
      initialPagination: {
        sortBy: 'desc',
        descending: false,
        page: 1,
        rowsPerPage: 50
      }
    }
  },
  methods: {
    setupTable: function () {
      this.columns = [
        { name: 'vote', label: 'Vote', field: 'vote', format: val => val ? 'Yay' : 'Nay', sortable: true, align: 'left', class: 'q-pa-sm' },
        { name: 'name', label: 'Name', field: 'name', align: 'left', sortable: true, class: 'q-pa-sm' },
        { name: 'location', label: 'Location', field: 'location', sortable: true, align: 'left', class: 'q-pa-sm' },
        { name: 'organization', label: 'Organization', field: 'organization', sortable: true, align: 'left', class: 'q-pa-sm', filter_type: 'select' },
        { name: 'date', label: 'Date', field: 'date', sortable: true, align: 'left', format: val => date.formatDate(val, 'M/D/YY'), class: 'q-pa-sm' }
      ]
    }
  },
  created () {
    this.setupTable()
  }
}
</script>
