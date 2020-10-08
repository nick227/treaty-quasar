<template>
  <q-page padding class="full-width">
    <div class="self-center">
      <q-form class="q-mb-lg q-pb-lg">
        <q-input v-model="name" label="Name" />
        <q-input v-model="avatar_url" type="url" label="Avatar URL" />
        <q-input v-model="point_value" type="number" label="Point Value" />
        <div class="full-width text-right q-pt-sm q-pb-lg">
          <q-btn class="q-mt-sm float-right" color="primary" @click="postForm">Submit</q-btn>
        </div>
      </q-form>
      <h6>Achievement Types:</h6>
      <ul class="q-mt-sm" style="border-top:1px solid lightgrey">
        <li class="row q-mb-sm q-pt-sm q-pb-sm" style="border-bottom:1px solid lightgrey" v-for="achievement_type in achievement_types" :key="achievement_type">
          <div class="col col-2"><img style="height:75px" :src="achievement_type.avatar_url" /></div>
          <div class="col">{{ achievement_type.name }}</div>
          <div class="col">{{ achievement_type.point_value }}</div>
        </li>
      </ul>
    </div>
  </q-page>
</template>
<script>
export default {
  meta () {
    return {}
  },
  name: 'AchievementAdminComponent.vue',
  components: {},
  data () {
    return {
      achievement_types: [],
      name: '',
      avatar_url: '',
      point_value: ''
    }
  },
  methods: {
    clear: function () {
      this.name = ''
      this.avatar_url = ''
      this.point_value = ''
    },
    postForm: async function () {
      const q = `${process.env.api}/achievement-types`
      const payload = {
        name: this.name,
        avatar_url: this.avatar_url,
        point_value: parseInt(this.point_value)
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
        .then((res) => {
          this.clear()
          this.getAchievementTypes()
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
    },
    getAchievementTypes: async function () {
      const q = `${process.env.api}/achievement-types?filter[order]=point_value%20DESC`
      const achievementTypes = await this.$axios.get(q)
      this.achievement_types = achievementTypes.data
    }
  },
  mounted () {
    this.getAchievementTypes()
  }
}
</script>
