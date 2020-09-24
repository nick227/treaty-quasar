<template>
    <q-page-container class="river-width">
      <q-page padding>
        <div v-if="isUser" class="row relative-position q-mb-sm full-width" style="height:35px;">
          <q-expansion-item v-model="editExpanded" switch-toggle-side dense-toggle label="Edit Treaty" class="z-top">
            <EditTreatyWidget
    :name="treaty.name"
    :description="treaty.description"
    :avatarUrl="treaty.avatar_url"
    :provisions="provisions"
    :reload="getTreaty"
    :key="'edit' + counter"
    :id="treaty.id" />
          </q-expansion-item>
        </div>
        <RatingWidget v-if="userOrganizationId" :entityId="treaty.id" :userOrganizationId="userOrganizationId" entityType="treaty" />
        <div class="row">
          <div class="col col-3"><q-img :src="treaty.avatar_url" /></div>
          <div class="col q-pl-md">
            <div class="">{{ org_a.name }} vs. {{ org_b.name }}</div>
            <h4 class="q-pa-none">{{ treaty.name }}</h4>
            <p class="q-pt-none">{{ treaty.description }}</p>
            <p v-if="treaty.creator" class="caption q-pt-none">Created by: {{ treaty.creator.name }}</p>
          </div>
        </div>
        <h5>Provisions:</h5>
        <q-separator class="q-mb-md" />
        <q-expansion-item v-if="isUser" v-model="expanded" label="Add Provision" class="full-width q-mb-sm bg-blue-grey-1">
          <AddProvision
          :id="treaty.id"
          :numProvisions="numProvisions"
          :reload="loadProvisions" />
        </q-expansion-item>
        <q-list class="full-width">
          <div v-for="(provision, index) in provisions" :key="provision.id" class="full-width q-mb-sm">
            <TreatyProvisionComponent v-if="userOrganizationId"
                :provision="provision"
                :index="index"
                :userOrganizationId="userOrganizationId"
                :creatorId="treaty.creator.id" />
          </div>
        </q-list>
        <TreatyVoteWidget class="q-mt-lg q-mb-sm" v-if="userOrganizationId"
        :reload="getVotes"
        :votes="votes"
        :key="'votesw' + counter"
        :id="treaty.id"
        :userOrganizationId="userOrganizationId" />
        <h5>Votes:</h5>
        <TreatyVotesTable
      :reload="getVotes"
      :key="'votest' + counter"
      :votes="votes"
      :id="treaty.id" />
        <CommentsWidget v-if="userOrganizationId"
              :entityId="treaty.id"
              entityType="treaty"
        ></CommentsWidget>
        <q-dialog v-model="verify_org" persistent>
          <q-card>
            <q-card-section class="row items-center">
              <q-avatar icon="done_outline" color="primary" text-color="white" /> <span class="q-ml-sm">Choose ONE organization to comment as.</span> </q-card-section>
            <q-card-actions align="right">
              <q-btn flat label="Cancel" color="primary" v-close-popup />
              <q-btn flat :label="org_a.name" color="primary" @click="setOrg(org_a)" v-close-popup />
              <q-btn flat :label="org_b.name" color="primary" @click="setOrg(org_b)" v-close-popup /> </q-card-actions>
          </q-card>
        </q-dialog>
      </q-page>
    </q-page-container>
</template>
<script>
import RatingWidget from 'components/widgets/RatingWidget.vue'
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import EditTreatyWidget from 'components/treaty/EditTreatyWidget.vue'
import AddProvision from 'components/treaty/AddProvision.vue'
import TreatyVoteWidget from 'components/treaty/TreatyVoteWidget.vue'
import TreatyVotesTable from 'components/treaty/TreatyVotesTable.vue'
import TreatyProvisionComponent from 'components/treaty/TreatyProvisionComponent.vue'
export default {
  name: 'TreatyPage',
  meta () {
    return {
      title: this.treatyName
    }
  },
  props: [],
  components: { AddProvision, CommentsWidget, TreatyVoteWidget, RatingWidget, TreatyVotesTable, EditTreatyWidget, TreatyProvisionComponent },
  data () {
    return {
      userOrganizationId: null,
      creatorName: null,
      creatorId: null,
      counter: 0,
      editExpanded: false,
      expanded: false,
      provisions: [],
      columns: [],
      numProvisions: 0,
      isUser: false,
      votes: [],
      treaty: {},
      verify_org: false,
      org_a: {},
      org_b: {},
      initialPagination: {
        sortBy: 'desc',
        descending: false,
        page: 1,
        rowsPerPage: 10
      }
    }
  },
  methods: {
    getTreaty: async function () {
      this.editExpanded = this.expanded = false
      const q = `${process.env.api}/treaties/${this.$route.params.id}?filter={"include":[{"relation":"creator"},{"relation":"conflict", "scope":{"include":[{"relation":"organization_a"},{"relation":"organization_b"}]}}]}`
      const treaty = await this.$axios.get(q)
      this.treaty = treaty.data
      this.org_a = this.treaty.conflict.organization_a
      this.org_b = this.treaty.conflict.organization_b
      this.getUserOrg()
      this.getVotes()
      this.loadProvisions()
      this.setupTable()
      this.isUser = this.$errorHandler.isLoggedInUser(this.treaty.creator_user_id)
    },
    setOrg: function (obj) {
      this.userOrganizationName = obj.name
      this.userOrganizationId = obj.id
      this.reload()
    },
    getUserOrg: async function () {
      const q = `${process.env.api}/user-to-organizations?filter[where][and][0][creator_user_id]=${this.$store.state.user.uid}&filter[where][or][1][organization_id]=${this.org_a.id}&filter[where][or][2][organization_id]=${this.org_b.id}`
      const joined = await this.$axios.get(q)
      this.joined = joined.data
      if (this.joined.length > 1) {
        this.verify_org = true
      }
      if (this.joined.length === 1) {
        this.userOrganizationId = this.joined[0].organization_id
        this.userOrganizationName = this.joined[0].name
      }
      if (this.joined.length === 0) {
        this.$q.notify({
          type: 'info',
          message: 'Please join organization to comment'
        })
      }
    },
    setupTable: function () {
      this.columns = [
        { name: 'position', align: 'left', label: 'Position', field: 'position', sortable: true, style: 'width:55px;' },
        { name: 'title', align: 'left', label: 'Title', field: 'title', sortable: true },
        { name: 'description', align: 'left', label: 'Description', field: 'description', sortable: true }
      ]
    },
    getVotes: async function () {
      const q = `${process.env.api}/votes?filter[where][treaty_id]=${this.$route.params.id}&filter[include][0][relation]=creator&filter[include][1][relation]=organization&filter[order]=create_date%20DESC`
      const votes = await this.$axios.get(q)
      this.votes = votes.data.map((item) => {
        return {
          creatorUserId: item.creator_user_id,
          date: item.create_date,
          name: item.creator.name,
          location: item.creator.location,
          organization: item.organization.name,
          vote: item.vote_type,
          sortable: true
        }
      })
      this.counter = this.counter + 1
    },
    loadProvisions: async function () {
      this.editExpanded = this.expanded = false
      const q = `${process.env.api}/treaty-provisions?filter[where][treaty_id]=${this.$route.params.id}&filter[order]=position%20ASC`
      const provisions = await this.$axios.get(q)
      this.provisions = provisions.data
      this.numProvisions = this.provisions.length ? this.provisions.length : 0
    }
  },
  created () {
    this.getTreaty()
  }
}
</script>
