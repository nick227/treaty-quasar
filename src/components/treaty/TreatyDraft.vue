<template>
  <q-layout view="Lhh lpR fff" style="width:800px; max-width:99%;" container class="bg-white">
    <q-header class="bg-primary">
      <q-toolbar>
        <q-toolbar-title class="q-pl-lg"></q-toolbar-title>
        <q-btn flat v-close-popup round dense icon="close" />
      </q-toolbar>
    </q-header>
    <q-page-container>
      <q-page padding>
        <div class="row relative-position q-mb-sm" style="height:35px;">
          <q-expansion-item switch-toggle-side dense-toggle label="Edit Treaty" class="absolute-left z-top full-width">
            <EditTreatyWidget
    :name="treaty.name"
    :description="treaty.description"
    :avatarUrl="treaty.avatar_url"
    :id="treatyId" />
          </q-expansion-item>
        </div>
        <RatingWidget :entityId="treatyId" :userOrganizationId="userOrganizationId" entityType="treaty" />
        <h4 class="q-pb-sm">{{ treaty.name }}</h4>
        <p class="q-pt-none">{{ treaty.description }}</p>
        <p class="caption q-pt-none">Created by: {{ treaty.creator_user_id }}</p>
        <q-expansion-item v-model="expanded" label="Add Provision" class="full-width q-mb-sm bg-blue-grey-1">
          <AddProvision
          :treatyId="treatyId"
          :numProvisions="numProvisions"
          :reload="loadProvisions" />
        </q-expansion-item>
        <q-list class="full-width">
          <div v-for="(provision, index) in provisions" :key="provision.id" class="full-width q-mb-sm">
            <TreatyProvisionComponent
                :provision="provision"
                :index="index" />
          </div>
        </q-list>
        <TreatyVoteWidget class="q-mt-lg q-mb-sm"
        :reload="getVotes"
        :key="'vote' + counter"
        :votes="votes"
        :id="treatyId"
        :userOrganizationId="userOrganizationId" />
        <TreatyVotesTable
      :reload="getVotes"
      :key="'votes' + counter"
      :votes="votes"
      :id="treatyId" />
        <CommentsWidget
              :entityId="treatyId"
              entityType="treaty"
        ></CommentsWidget>
      </q-page>
    </q-page-container>
  </q-layout>
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
  name: 'TreatyDraft',
  meta () {
    return {
      title: this.treatyName
    }
  },
  props: ['treatyId', 'userOrganizationId'],
  components: { AddProvision, CommentsWidget, TreatyVoteWidget, RatingWidget, TreatyVotesTable, EditTreatyWidget, TreatyProvisionComponent },
  data () {
    return {
      counter: 0,
      likeKey: 0,
      expanded: false,
      provisions: [],
      columns: [],
      numProvisions: 0,
      votes: [],
      treaty: {},
      initialPagination: {
        sortBy: 'desc',
        descending: false,
        page: 1,
        rowsPerPage: 10
      }
    }
  },
  watch: {
    userOrganizationId: function () {
      this.likeKey++
    }
  },
  methods: {
    getTreaty: async function () {
      // , 'userOrganizationId', 'treatyName', 'treatyDesc', 'treatyCreator', 'treatyAvatarUrl'
      const q = `${process.env.api}/treaties/${this.treatyId}`
      const treaty = await this.$axios.get(q)
      this.treaty = treaty.data
    },
    setupTable: function () {
      this.columns = [
        { name: 'position', align: 'left', label: 'Position', field: 'position', sortable: true, style: 'width:55px;' },
        { name: 'title', align: 'left', label: 'Title', field: 'title', sortable: true },
        { name: 'description', align: 'left', label: 'Description', field: 'description', sortable: true }
      ]
    },
    getVotes: async function () {
      const q = `${process.env.api}/votes?filter[where][treaty_id]=${this.treatyId}&filter[include][0][relation]=creator&filter[include][1][relation]=organization&filter[order]=create_date%20DESC`
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
      this.counter = this.counter + 1
    },
    loadProvisions: async function () {
      const q = `${process.env.api}/treaty-provisions?filter[where][treaty_id]=${this.treatyId}&filter[order]=position%20ASC`
      const provisions = await this.$axios.get(q)
      this.provisions = provisions.data
      this.numProvisions = this.provisions.length ? this.provisions.length : 0
    }
  },
  created () {
    this.getTreaty()
    this.getVotes()
    this.loadProvisions()
    this.setupTable()
  }
}
</script>
