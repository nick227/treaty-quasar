<template>
  <div class="bg-grey-6">
    <h6 class="q-pa-sm q-ml-md">New Conflict</h6>
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
    type="url"
    />
    <div class="row">
      <div class="col col-5 float-left">
          <q-select
        filled
        required
        :value="orgA"
        use-input
        :readonly="optAdisable"
        hide-selected
        fill-input
        input-debounce="0"
        behavior="menu"
        :options="optionsA"
        @filter="filterFnA"
        @input-value="setModelA"
        placeholder="Party A"
      >
        <template v-slot:no-option>
          <q-item>
            <q-item-section class="text-grey">
              No results
            </q-item-section>
          </q-item>
        </template>
      </q-select>
          </div>
          <div class="col col-2 text-center q-pt-md">vs.</div>
      <div class="col col-5 float-right"><q-select
        filled
        required
        :value="orgB"
        use-input
        hide-selected
        fill-input
        input-debounce="0"
        behavior="menu"
        :options="optionsB"
        @filter="filterFnB"
        @input-value="setModelB"
        placeholder="Party B"
      >
        <template v-slot:no-option>
          <q-item>
            <q-item-section class="text-grey">
              No results
            </q-item-section>
          </q-item>
        </template>
      </q-select>
   </div>
    </div>
    <div class="full-width row">
      <div class="text-left col-8 col text-red q-mt-sm row">
      </div>
      <div class="text-right col col-4 q-mt-lg">
          <q-btn label="Submit" type="submit" color="primary"/>
      </div>
    </div>
  </q-form>
  </div>
</template>
<script>
import AddAchievementMixin from 'components/mixins/AddAchievementMixin.vue'
export default {
  name: 'CreateConflictWidget',
  data () {
    return {
      optAdisable: false,
      orgA: null,
      orgB: null,
      organizationsA: [],
      organizationsB: [],
      optionsA: [],
      optionsB: [],
      organizationsObj: [],
      name: '',
      description: '',
      avatar_url: ''
    }
  },
  props: {
    defaultOrgName: {
      type: String,
      required: false
    },
    reload: {
      type: Function,
      required: false
    }
  },
  mixins: [AddAchievementMixin],
  async created () {
    await this.getOrgs()
    if (typeof this.defaultOrgName === 'string') {
      this.orgA = this.defaultOrgName
      this.optAdisable = true
      this.optionsA = []
    } else {
      this.optionsA = this.organizationsA
    }
    this.optionsB = this.organizationsB
  },
  methods: {
    getOrgs: async function () {
      const q = `${process.env.api}/organizations?filter[order]=name%20ASC`
      const organizations = await this.$axios.get(q)
      this.organizationsA = this.organizationsB = organizations.data.map((obj) => { return obj.name })
      for (var i = 0, length1 = organizations.data.length; i < length1; i++) {
        this.organizationsObj[organizations.data[i].name] = organizations.data[i].id
      }
    },
    filterFnA (val, update, abort) {
      if (val === '') {
        update(() => {
          this.optionsA = this.organizationsA
        })
        return
      }
      update(() => {
        const needle = val.toLocaleLowerCase()
        this.optionsA = this.organizationsA.filter(v => v.toLocaleLowerCase().indexOf(needle) > -1)
      })
    },
    filterFnB (val, update, abort) {
      if (val === '') {
        update(() => {
          this.optionsB = this.organizationsB
        })
        return
      }
      update(() => {
        const needle = val.toLocaleLowerCase()
        this.optionsB = this.organizationsB.filter(v => v.toLocaleLowerCase().indexOf(needle) > -1)
      })
    },
    setModelA (val) {
      this.orgA = val
    },
    setModelB (val) {
      this.orgB = val
    },
    postForm: async function () {
      if (!this.$errorHandler.loggedInCheck()) { return false }
      if (this.orgValidate()) {
        const q = `${process.env.api}/conflicts`
        const payload = {
          creator_user_id: this.$store.state.user.uid,
          name: this.name,
          description: this.description,
          organization_a_id: this.organizationsObj[this.orgA],
          organization_b_id: this.organizationsObj[this.orgB],
          avatar_url: this.avatar_url
        }
        const res = await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
        this.addAchievement('Added a Conflict')
        if (typeof this.reload === 'function') {
          this.reload(res)
        } else {
          this.$router.push('/conflict/' + res.data.id)
        }
      }
    },
    orgValidate: function () {
      if (!this.organizationsA.includes(this.orgA)) {
        this.$q.notify({
          type: 'negative',
          message: 'Invalid Party A'
        })
        return false
      }
      if (!this.organizationsB.includes(this.orgB)) {
        this.$q.notify({
          type: 'negative',
          message: 'Invalid Party B'
        })
        return false
      }
      return true
    }
  }
}
</script>
