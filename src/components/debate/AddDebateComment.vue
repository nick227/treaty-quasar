<template>
  <q-form @submit="postComment" greedy class="q-pa-md bg-grey-4">
    <q-input label='Message' v-model="text" autogrow />
    <div class="full-width row">
      <div class="text-right col q-mt-lg">
          <q-btn label="Submit" type="submit" color="primary"/>
      </div>
    </div>
  </q-form>
</template>
<script>
export default {
  name: 'AddDebateComment',
  props: ['debateId', 'parentId', 'reload'],
  data () {
    return {
      text: ''
    }
  },
  methods: {
    postComment: async function () {
      const q = `${process.env.api}/debate-comments`
      const payload = {
        text: this.text,
        creator_user_id: this.$store.state.user.uid,
        debate_id: this.debateId,
        parent_comment_id: parseInt(this.parentId)
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } }).then(() => {
        this.$q.notify({
          type: 'positive',
          message: 'Comment Saved'
        })
        this.reload()
        this.text = ''
      }).catch((err) => {
        this.$q.notify({
          type: 'negative',
          message: 'Error saving debate comment: ' + err
        })
      })
    }
  },
  mounted () {}
}
</script>
