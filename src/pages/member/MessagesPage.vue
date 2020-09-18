<template>
    <q-page class="q-pa-md text-left full-width">
      <h4 class="full-width text-left">Messages</h4>
      <h3 v-if="!messages.length">Inbox is empty.</h3>
      <q-list>
        <div class="row q-pa-lg" style="border-bottom:1px solid lightgrey" v-for="message in messages" :key="message.id">
          <div class="col col-1">
            <q-img :src="message.creator_avatar" />
          </div>
          <div class="col q-pl-lg q-pr-sm q-pb-lg">
            <h6 class="q-pa-none">{{ message.creator_name }}</h6>
            <p class="q-pa-none">{{ message.create_date }}</p>
            <div class="q-pt-sm"><span>{{ message.text }}</span><span v-if="message.hidden_text && message.show_more">{{ message.hidden_text}}</span></div><q-btn class="q-mt-md" v-if="message.hidden_text && !message.show_more" @click="message.show_more = true">show more</q-btn><q-btn class="q-mt-md" v-if="message.hidden_text && message.show_more" @click="message.show_more = false">hide</q-btn>
          </div>
          <div class="col col-1 text-right align-right flex-right">
            <q-btn color="grey" @click="deleteMsg(message.id)" icon="delete" square size="11px" style="width:36px; height:30px;" />
          </div>
        </div>
      </q-list>
    </q-page>
</template>
<script>
export default {
  meta () {
    return {
      title: 'Messages'
    }
  },
  name: 'MessagesPage',
  components: {},
  data () {
    return {
      messages: []
    }
  },
  methods: {
    deleteMsg: async function (id) {
      const q = `${process.env.api}/user-messages/${id}`
      const payload = {
        id: id,
        status: 2
      }
      console.log(q)
      console.log(payload)
      await this.$axios.patch(q, payload)
        .then((res) => {
          this.loadMessages()
          this.$q.notify({
            type: 'positive',
            message: 'Update Success'
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: 'Error Deleting: ' + err
          })
        })
    },
    loadMessages: async function () {
      const q = `${process.env.api}/user-messages?filter[where][and][0][user_id]=${this.$store.state.user.uid}&filter[where][and][1][status][lt]=2&filter[include][][relation]=creator&filter[order]=create_date%20DESC`
      console.log(q)
      const messages = await this.$axios.get(q)
      this.messages = messages.data.map((obj) => {
        const messageTxt = this.trunc(obj.text)
        return {
          creator_avatar: obj.creator.avatar_url,
          creator_name: obj.creator.name,
          text: messageTxt[0],
          id: obj.id,
          create_date: obj.create_date,
          status: obj.status,
          hidden_text: messageTxt[1],
          show_more: false
        }
      })
      this.markRead()
    },
    trunc: function (str) {
      const res = []
      const maxlen = 350
      if (str.length > maxlen) {
        let breakpoint = false
        let i = maxlen
        while (i < str.length && !breakpoint) {
          breakpoint = str[i] === ' ' ? i : false
          i++
        }
        res[0] = str.substring(0, breakpoint)
        res[1] = str.substring(breakpoint, str.length)
      } else {
        res[0] = str
        res[1] = ''
      }
      return res
    },
    markRead: async function () {
      const q = `${process.env.api}/user-messages`
      for (let i = 0; i < this.messages.length; i++) {
        if (this.messages[i].status === 0) {
          const payload = {
            id: this.messages[i].id,
            status: 1
          }
          await this.$axios.patch(q, payload)
            .catch((err) => {
              this.$q.notify({
                type: 'negative',
                message: 'Error Marking Read: ' + err
              })
            })
        }
      }
      this.$store.commit('user/updateMsgCount', 0)
    }
  },
  created () {
    this.loadMessages()
  }
}
</script>
