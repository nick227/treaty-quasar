<template>
  <q-layout view="Lhh lpR fff" container class="z-max relative-position bg-white full-height">
    <q-header class="bg-grey" style="">
      <q-toolbar>
        <q-toolbar-title class="q-pl-lg text-center">{{ organization.name }} Chat</q-toolbar-title>
        <q-btn flat v-close-popup round dense icon="close" />
      </q-toolbar>
    </q-header>
    <q-page-container class="">
      <q-page padding class="q-mt-lg">
        <q-form class="row" @submit="addChat">
          <div class="col col-10">
            <q-input
             class="full-width"
             filled
             required
             v-model="message"
             @keydown.enter = "addChat"
             autogrow
             type="textarea"
            />
          </div>
          <div class="col col-2 text-center">
            <q-btn label="submit" type="submit" class="q-ml-sm full-height full-width" color="primary"></q-btn>
          </div>
        </q-form>
        <div style="height:70vh;" class="q-pt-md q-mt-md q-pt-lg relative-position overflow-auto">
          <h5 class="q-pt-lg q-pl-sm" v-if="!chats.length">Be first to comment.</h5>
          <ul class="alt-color">
          <li v-for="chat in chats" :key="chat.id" class="q-pt-md">
            <div class="row q-pl-lg">
              <div class="col col-1 text-center q-pt-sm">
                <q-avatar class="q-mr-sm"><img :src="chat.creator.avatar_url" /></q-avatar>
              </div>
              <div class="col col-11 q-pl-sm q-pr-sm">
                <router-link :to="'/profile/'+chat.creator.id"><div class=""><span class="text-bold">{{ chat.creator.name }}</span></div></router-link>
                <div class=""><span class="text-caption">{{ readyDate(chat.create_date) }}</span></div>
                <div v-html="readyChat(chat.message)"></div>
              </div>
            <q-separator class="q-mt-md" />
            </div>
          </li>
        </ul>
          <div v-if="!done" v-intersection="onIntersection" class="full-width text-center">
            <q-spinner-dots color="primary" size="40px" />
          </div>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>
<script>
import TextToolsMixin from 'components/mixins/TextToolsMixin.vue'
import DateToolsMixin from 'components/mixins/DateToolsMixin.vue'
export default {
  name: 'OrganizationChatWidget',
  mixins: [TextToolsMixin, DateToolsMixin],
  components: {},
  data () {
    return {
      pointer: 0,
      limit: 8,
      done: false,
      message: '',
      chats: []
    }
  },
  props: {
    organization: {
      type: Object,
      required: true
    }
  },
  methods: {
    readyChat: function (str) {
      return this.checkStr(str)
    },
    readyDate: function (d) {
      return this.timeSince(d)
    },
    onIntersection: function (index, done) {
      this.pointer = this.pointer + this.limit
      this.getChats()
    },
    addChat: async function () {
      const q = `${process.env.api}/organization-chats`
      const message = this.message
      this.message = ''
      const payload = {
        message: message,
        creator_user_id: this.$store.state.user.uid,
        organization_id: this.organization.id
      }
      const res = await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      const nq = `${process.env.api}/organization-chats/${res.data.id}?filter[include][0][relation]=creator`
      const newMessage = await this.$axios.get(nq)
      this.chats.unshift(newMessage.data)
    },
    getChats: async function () {
      const q = `${process.env.api}/organization-chats?filter[where][organization_id]=${this.organization.id}&filter[include][0][relation]=creator&filter[order]=create_date%20DESC&filter[limit]=${this.limit}&filter[skip]=${this.pointer}`
      console.log(q)
      const chats = await this.$axios.get(q)
      if (this.limit > chats.data.length) {
        this.done = true
      }
      this.chats = this.chats.concat(chats.data)
    }
  },
  mounted () {
    this.getChats()
  }
}
</script>
