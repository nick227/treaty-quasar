<template>
  <div>
  <q-form @submit="postForm" greedy class="q-pa-md bg-grey-4">
    <q-input
     filled
     required
      v-model="name"
      label="Name"
    />
      <q-separator />
    <q-input
     filled
     required
      label="Description"
      v-model="description"
      autogrow
      type="textarea"
    />
      <q-separator />
    <q-input
    filled
    required
    v-model="avatar_url"
    label="Avatar URL"
    />
    <div class="text-right q-mt-lg">
        <q-btn label="Submit" type="submit" color="primary"/>
    </div>
  </q-form>
  </div>
</template>
<script>
import AddAchievementMixin from 'components/mixins/AddAchievementMixin.vue'
export default {
  name: 'CreateOrganizationWidget',
  props: ['reload'],
  data () {
    return {
      name: '',
      description: '',
      avatar_url: '',
      organizations: []
    }
  },
  mixins: [AddAchievementMixin],
  methods: {
    postForm: async function () {
      const q = `${process.env.api}/organizations`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        description: this.description,
        avatar_url: this.avatar_url,
        name: this.name
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
        .then((res) => {
          this.clear()
          this.reload()
          this.addAchievement('Added an Organization')
          this.$q.notify({
            type: 'positive',
            message: 'Create Success'
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: 'Error creating: ' + err
          })
        })
      // this.$router.push('/organization/' + res.data.id)
    },
    clear: function () {
      this.description = ''
      this.name = ''
      this.avatar_url = ''
    }
  }
}
</script>
