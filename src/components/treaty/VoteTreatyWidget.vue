<template>
  <q-page>
  <div class="row">
    <div class="col col-12 q-pa-lg row flex-center">
      <h4 class="q-mr-lg">Do you agree to this treaty?</h4>
    <q-btn
      class="q-ma-lg"
      padding="xl"
      color="positive"
      round
      label="AYE"
      @click="confirm(1)"
    />
    <q-btn
      class="q-ma-lg"
      padding="xl"
      color="negative"
      round
      label="NAY"
      @click="confirm(0)"
    />
    </div>
    <q-separator />
    <div class="row text-center flex-center full-width"><div class="text-green q-mr-md">{{ num_yay }} Yay</div><div>/</div><div class="text-red q-ml-md">{{ num_nay }} Nay</div></div>
    <q-dialog v-model="verify" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-avatar icon="done_outline" color="primary" text-color="white" />
          <span class="q-ml-sm">Are you sure?</span>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancel" color="primary" v-close-popup />
          <q-btn flat :label="'Vote ' + voteTxt" color="primary" @click="vote" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
  <div class="row full-width">
    <q-table
    class="full-width align-left table"
    title="Votes"
    dense
    flat
    :data="votes"
    :columns="columns"
    row-key="id"
    :pagination="initialPagination"
    />
  </div>
  </q-page>
</template>
<script>
export default {
  name: 'VoteTreatyWidget',
  props: ['id', 'organizationId'],
  data () {
    return {
      num_yay: 0,
      num_nay: 0,
      voteVal: null,
      verify: false,
      voteTxt: null,
      columns: [],
      votes: [],
      initialPagination: {
        sortBy: 'desc',
        descending: false,
        page: 1,
        rowsPerPage: 10
      }
    }
  },
  mounted () {
    this.getVotes()
  },
  methods: {
    confirm: async function (res) {
      this.voteVal = res
      this.voteTxt = res ? 'Yay' : 'Nay'
      this.verify = true
    },
    vote: async function () {
      const q = `${process.env.api}/votes`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        treaty_id: parseInt(this.id),
        organization_id: parseInt(this.organizationId),
        vote_type: this.voteVal
      }
      console.log(payload)
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } }).then(() => {
        this.getVotes()
        this.$q.notify({
          type: 'positive',
          message: 'Vote Received'
        })
      }).catch((err) => {
        this.$q.notify({
          type: 'negative',
          message: err
        })
      })
    },
    getVotes: async function () {
      const q = `${process.env.api}/votes?filter[where][treaty_id]=${this.id}&filter[include][0][relation]=creator&filter[include][1][relation]=organization&filter[order]=create_date%20DESC`
      const votes = await this.$axios.get(q)
      this.votes = votes.data.map((item) => {
        return {
          date: item.create_date,
          name: item.creator.name,
          location: item.creator.location,
          organization: item.organization.name,
          vote: item.vote_type,
          sortable: true
        }
      })
      this.setupTable()
      this.getSums()
    },
    getSums: function () {
      for (let i = 0; i < this.votes.length; i++) {
        this.num_yay += this.votes[i].vote ? 1 : 0
        this.num_nay += !this.votes[i].vote ? 1 : 0
      }
    },
    setupTable: function () {
      this.columns = [
        { name: 'vote', label: 'Vote', field: 'vote', format: val => val ? 'Yay' : 'Nay', sortable: true },
        { name: 'name', label: 'Name', field: 'name' },
        { name: 'location', label: 'Location', field: 'location', sortable: true },
        { name: 'organization', label: 'Organization', field: 'organization', sortable: true },
        { name: 'date', label: 'Date', field: 'date' }
      ]
    }

  }
}
</script>
