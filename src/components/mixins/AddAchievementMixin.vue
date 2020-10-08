<template>
  <div></div>
</template>
<script>
export default {
  name: 'AddAchievementMixin',
  methods: {
    /*
    type: string:
      Treaty Builder*
      Comment Liked
      Added an Organization*
      Added a Conflict*
      Grievance Maker*
      Offer Maker*
    */
    addAchievement: async function (type) {
      let q = `${process.env.api}/achievement-types?filter[where][name]=${type}`
      const achievementType = await this.$axios.get(q)
      this.achievementTypeId = achievementType.data[0].id
      const payload = {
        owner_user_id: this.$store.state.user.uid,
        achievement_type_id: this.achievementTypeId
      }
      q = `${process.env.api}/user-achievements`
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
        .then((res) => {
          this.$q.notify({
            type: 'positive',
            message: `You received new Achievement: ${type}`
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: 'Error creating: ' + err
          })
        })
    }
  },
  mounted () {}
}
</script>
