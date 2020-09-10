<template>
  <div>
      <q-btn class="full-width" color="accent" label="Add New" @click="prompt = true" />
      <q-dialog v-model="prompt" persistent>
      <q-card style="min-width: 350px">
        <q-card-section color="secondary">
          <div class="text-h6">Add {{ entityType }}</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input required dense v-model="title" placeholder="title" autofocus />
          <q-input required dense v-model="description" placeholder="description" autogrow />
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="CANCEL" @click="clearForm" v-close-popup />
          <q-btn flat label="SUBMIT" @click="submitForm" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>
<script>
export default {
  data () {
    return {
      prompt: false,
      title: '',
      description: ''
    }
  },
  props: ['entityType', 'treatyId', 'organizationId', 'fn'],
  methods: {
    clearForm: function () {
      this.title = ''
      this.description = ''
    },
    submitForm: async function () {
      const q = `http://localhost:3000/${this.entityType.toLowerCase()}`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        title: this.title,
        description: this.description,
        organization_id: this.organizationId,
        treaty_id: this.treatyId
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.clearForm()
      this.fn()
    }
  }
}
</script>
