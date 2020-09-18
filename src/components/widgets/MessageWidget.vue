<template>
  <div>
     <q-card class="message-card">
        <q-card-section class="q-pt-none">
      <q-toolbar class="q-pa-none" >
        <q-toolbar-title>Sending to {{ receiverName }}:</q-toolbar-title>
        <q-btn flat v-close-popup round dense icon="close" />
      </q-toolbar>
      <q-input
      class=""
      v-model="text"
      label="Message"
      lazy-rules
      outlined
      clearable
      rows="3"
      autofocus
      required
      type="textarea"
    />
        </q-card-section>
        <q-card-actions align="right">
          <q-btn label="CANCEL" color="primary" v-close-popup />
          <q-btn label="SEND"  color="primary" @click="sendMessage" />
        </q-card-actions>
      </q-card>
  </div>
</template>
<script>
import { escape } from 'sqlstring'
export default {
  name: 'MessageWidget',
  props: ['senderUserId', 'receiverUserId', 'receiverName', 'done'],
  methods: {
    sendMessage: async function () {
      const q = `${process.env.api}/user-messages`
      const payload = {
        text: escape(this.text),
        creator_user_id: this.senderUserId,
        user_id: this.receiverUserId,
        status: 0
      }
      console.log(q)
      console.log(payload)
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } }).then(() => {
        this.$q.notify({
          type: 'positive',
          message: 'Message Send'
        })
        this.text = ''
        this.done()
      }).catch((err) => {
        this.$q.notify({
          type: 'negative',
          message: 'Message Failed: ' + err
        })
      })
    }
  },
  data () {
    return {
      text: ''
    }
  }
}
</script>
