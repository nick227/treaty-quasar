<template>
  <div class="row">
    <div class="col bg-blue-grey-1 col-12 q-pl-lg q-pr-lg q-pt-sm q-pb-sm row flex-center">
      <h6 class="q-ma-lg">Do you agree to this treaty?</h6>
      <div class="row flex-center text-center" style="flex-wrap:nowrap; white-space:nowrap;">
        <q-btn
          class="q-mr-sm"
          padding="lg"
          color="positive"
          round
          label="AYE"
          @click="confirm(1)"
        />
        <q-btn
          class="q-ma-md"
          padding="lg"
          color="negative"
          round
          label="NAY"
          @click="confirm(0)"
        />
      </div>
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
</template>
<script>
export default {
  name: 'TreatyVoteWidget',
  props: ['id', 'userOrganizationId', 'votes', 'reload'],
  data () {
    return {
      count: 0,
      voteVal: null,
      verify: false,
      voteTxt: null
    }
  },
  computed: {
    num_yay: function () {
      return this.votes.filter((o) => { return o.vote === 1 }).length
    },
    num_nay: function () {
      return this.votes.filter((o) => { return o.vote === 0 }).length
    }
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
        organization_id: parseInt(this.userOrganizationId),
        vote_type: this.voteVal
      }
      console.log(q)
      console.log(payload)
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } }).then(() => {
        this.reload()
        this.$q.notify({
          type: 'positive',
          message: 'Vote Received'
        })
      }).catch((err) => {
        this.$q.notify({
          type: 'negative',
          message: 'Voting error: ' + err
        })
      })
    }
  }
}
</script>
