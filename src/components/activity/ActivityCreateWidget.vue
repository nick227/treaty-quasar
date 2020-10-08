<template>
<div class="full-width">
  <q-form @submit="postActivity">
    <q-editor
      class="full-width bg-blue-grey-2"
      v-model="newActivity"
      flat
      height="100px"
      content-class="bg-white-5"
      toolbar-text-color="black"
      toolbar-toggle-color="grey-8"
      placeholder="What's up?"
      toolbar-bg="grey-4"
      :toolbar="[
        ['bold', 'italic', 'underline'],
        [{
          label: $q.lang.editor.formatting,
          icon: $q.iconSet.editor.formatting,
          list: 'no-icons',
          options: ['p', 'h3', 'h4', 'h5', 'h6', 'code']
        }]
      ]"
    />
    <div class="row">
      <q-btn type="submit" color="primary full-width">submit</q-btn>
    </div>
  </q-form>
  </div>
</template>
<script>
export default {
  name: 'ActivityCreateWidget',
  props: ['reload', 'entityType', 'entityId'],
  components: {},
  data () {
    return {
      newActivity: ''
    }
  },
  methods: {
    postActivity: async function () {
      const q = `${process.env.api}/activities`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        message: this.newActivity,
        entity_type: 'activity'
      }
      if (typeof this.entity_id === 'number') {
        payload.entity_id = this.entityId
      }
      console.log(q)
      console.log(payload)
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.newActivity = ''
      this.reload()
    }
  }
}
</script>
