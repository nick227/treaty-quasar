<template>
  <div>
      <q-btn class="full-width" color="accent" label="Add Topic" @click="openForm" />
      <q-dialog v-model="prompt" persistent>
      <q-card style="min-width: 350px">
        <q-card-section color="secondary">
          <div class="text-h6 capitalize">Add Topic</div>
        </q-card-section>
        <q-card-section class="q-pt-none">
          <q-input
           dense
           required
            v-model="title"
            placeholder="Title"
          />
          <q-input
           dense
           required
            placeholder="Description"
            v-model="description"
            autogrow
            type="textarea"
          />
          <q-input
          dense
          v-model="avatar_url"
          placeholder="Avatar URL"
          type="url"
          />
        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="CANCEL" @click="clearForm" v-close-popup />
          <q-btn flat label="SUBMIT" @click="postForm" v-close-popup />
        </q-card-actions>
        </q-card-section>
      </q-card>
    </q-dialog>
  </div>
</template>
<script>
export default {
  name: 'CreateDebateWidget',
  props: ['userOrganizationId', 'conflictId', 'reload'],
  data () {
    return {
      title: '',
      description: '',
      avatar_url: '',
      prompt: false
    }
  },
  methods: {
    openForm: function () {
      this.title = ''
      this.description = ''
      this.avatar_url = ''
      this.prompt = true
    },
    clearForm: function () {
      this.title = ''
      this.avatar_url = ''
      this.description = ''
    },
    postForm: async function () {
      const q = `${process.env.api}/debates`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        creator_organization_id: this.userOrganizationId,
        description: this.description,
        avatar_url: this.avatar_url,
        title: this.title,
        conflict_id: this.conflictId
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
        .then((res) => {
          this.clear()
          this.reload()
          this.$q.notify({
            type: 'positive',
            message: 'Debate Created'
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: 'Error adding debate: ' + err
          })
        })
    },
    clear: function () {
      this.description = ''
      this.title = ''
      this.avatar_url = ''
    }
  }
}
</script>
