<template>
  <div>
  <q-form @submit="postForm" greedy class="q-pa-md bg-grey-4">
    <q-input
     filled
     required
      v-model="title"
      placeholder="Title"
    />
      <q-separator />
    <q-input
     filled
     required
      placeholder="Description"
      v-model="description"
      autogrow
      type="textarea"
    />
      <q-separator />
    <q-input
    filled
    v-model="avatar_url"
    placeholder="Avatar URL"
    type="url"
    />
    <div class="text-right q-mt-lg">
        <q-btn label="Submit" type="submit" color="primary"/>
    </div>
  </q-form>
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
      organizations: []
    }
  },
  methods: {
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
