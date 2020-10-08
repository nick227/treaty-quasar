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
          :disabled="voted"
          label="AYE"
          @click="confirm(1)"
        />
        <q-btn
          class="q-ma-md"
          padding="lg"
          color="negative"
          round
          :disabled="voted"
          label="NAY"
          @click="confirm(0)"
        />
      </div>
    </div>
    <q-separator />
    <div class="row text-center justify-center full-width"><div class="text-right col q-pr-lg">total:</div><div class="text-green q-mr-md">{{ num_yay }} Yay</div><div>/</div><div class="text-red q-ml-md">{{ num_nay }} Nay</div></div>
    <div class="row text-center justify-center full-width"><div class="text-right col q-pr-lg">{{ orgAname }}:</div><div class="text-green q-mr-md">{{ org_a_votes.yay }} Yay</div><div>/</div><div class="text-red q-ml-md">{{ org_a_votes.nay }} Nay</div></div>
    <div class="row text-center justify-center full-width"><div class="text-right col q-pr-lg">{{ orgBname }}:</div><div class="text-green q-mr-md">{{ org_b_votes.yay }} Yay</div><div>/</div><div class="text-red q-ml-md">{{ org_b_votes.nay }} Nay</div></div>
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
  props: ['id', 'userOrganizationId', 'votes', 'reload', 'orgAname', 'orgBname'],
  data () {
    return {
      count: 0,
      voteVal: null,
      voted: false,
      verify: false,
      voteTxt: null
    }
  },
  computed: {
    org_a_votes: function () {
      return {
        yay: this.votes.filter((o) => {
          return o.vote === 1 && o.organization === this.orgAname
        }).length,
        nay: this.votes.filter((o) => { return o.vote === 0 && o.organization === this.orgAname }).length
      }
    },
    org_b_votes: function () {
      return {
        yay: this.votes.filter((o) => { return o.vote === 1 && o.organization === this.orgBname }).length,
        nay: this.votes.filter((o) => { return o.vote === 0 && o.organization === this.orgBname }).length
      }
    },
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
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } }).then(() => {
        this.reload()
        this.voted = true
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
