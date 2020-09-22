<template>
  <div>
  <q-form @submit="postForm" greedy class="q-pa-md bg-grey-4">
    <q-input
     filled
     required
      v-model="name"
      placeholder="Name"
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
    required
    v-model="avatar_url"
    placeholder="Avatar URL"
    />
    <div class="text-right q-mt-lg">
        <q-btn label="Submit" type="submit" color="primary"/>
    </div>
  </q-form>
  </div>
</template>
<script>
export default {
  name: 'CreateOrganizationWidget',
  data () {
    return {
      name: '',
      description: '',
      avatar_url: '',
      organizations: []
    }
  },
  methods: {
    postForm: async function () {
      const q = `${process.env.api}/organizations`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        description: this.description,
        avatar_url: this.avatar_url,
        name: this.name
      }
      const res = await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.$router.push('/organization/' + res.data.id)
    },
    reload: function () {
      this.description = ''
      this.name = ''
      this.avatar_url = ''
    }
  }
}
</script>
