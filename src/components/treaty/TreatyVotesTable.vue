<template>
  <div class="row full-width">
    <q-table
    class="full-width align-left table q-pa-sm"
    title="Votes"
    dense
    flat
    :data="votes"
    :columns="columns"
    row-key="id"
    :pagination="initialPagination"
    />
  </div>
</template>
<script>
export default {
  name: 'TreatyVotesTable',
  props: ['votes', 'id'],
  data () {
    return {
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
        { name: 'vote', label: 'Vote', field: 'vote', format: val => val ? 'Yay' : 'Nay', sortable: true, align: 'left' },
        { name: 'name', label: 'Name', field: 'name', align: 'left', sortable: true },
        { name: 'location', label: 'Location', field: 'location', sortable: true, align: 'left' },
        { name: 'organization', label: 'Organization', field: 'organization', sortable: true, align: 'left' },
        { name: 'date', label: 'Date', field: 'date', sortable: true, align: 'left' }
      ]
    }
  },
  mounted () {
    this.setupTable()
  }
}
</script>
