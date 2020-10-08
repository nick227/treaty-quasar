<template>
  <div>
      <q-btn class="full-width" color="accent" :label="'Add '+entityType" @click="openForm" />
      <q-dialog v-model="prompt" persistent>
      <q-card style="min-width: 350px">
        <q-card-section color="secondary">
          <div class="text-h6 capitalize">Add {{ entityType }}</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-select v-model="type" :options="options" required label="Organization" />
          <q-input autogrow required dense maxlength="100" @keyup="updateCount" :hint="charsRemain + ' characters'" v-model="title" label="Title" />
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
import AddAchievementMixin from 'components/mixins/AddAchievementMixin.vue'
export default {
  name: 'AddConflictItem',
  data () {
    return {
      prompt: false,
      title: '',
      description: '',
      type: '',
      options: [{ label: this.orgA.name, value: this.orgA.id }, { label: this.orgB.name, value: this.orgB.id }],
      charsRemain: 100,
      maxChars: 100
    }
  },
  mixins: [AddAchievementMixin],
  mounted () {},
  props: ['entityType', 'conflictId', 'reload', 'userOrganizationId', 'orgA', 'orgB'],
  methods: {
    updateCount: function () {
      this.charsRemain = this.maxChars - this.title.length
    },
    openForm: function () {
      if (!this.$errorHandler.organizationCheck(this.userOrganizationId)) { return false }
      this.title = ''
      this.description = ''
      this.prompt = true
    },
    clearForm: function () {
      this.title = ''
      this.type = ''
      this.charsRemain = this.maxChars
      this.description = ''
    },
    submitForm: async function () {
      const q = `${process.env.api}/${this.entityType.toLowerCase()}s`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        creator_organization_id: this.userOrganizationId,
        title: this.title,
        organization_id: this.type.value,
        conflict_id: this.conflictId
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      const key = this.entityType === 'grievance' ? 'Grievance Maker' : 'Offer Maker'
      this.addAchievement(key)
      this.clearForm()
      this.reload()
    }
  }
}
</script>
