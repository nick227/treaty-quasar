<template>
  <div>
    <h6 class="q-mb-sm q-mt-lg">New Treaty</h6>
  <q-form @submit="postForm" greedy class="self-center">
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
        hide-selected
        fill-input
        input-debounce="0"
        behavior="menu"
        :options="organizationsA"
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
        :options="organizationsB"
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
export default {
  name: 'TreatyList',
  data () {
    return {
      orgA: null,
      orgB: null,
      organizationsA: [],
      organizationsB: [],
      organizationsObj: [],
      name: '',
      description: '',
      avatar_url: ''
    }
  },
  async created () {
    this.getOrgs()
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
          this.options = this.organizationsA
        })
        return
      }
      update(() => {
        const needle = val.toLocaleLowerCase()
        this.options = this.organizationsA.filter(v => v.toLocaleLowerCase().indexOf(needle) > -1)
      })
    },
    filterFnB (val, update, abort) {
      if (val === '') {
        update(() => {
          this.options = this.organizationsB
        })
        return
      }
      update(() => {
        const needle = val.toLocaleLowerCase()
        this.options = this.organizationsB.filter(v => v.toLocaleLowerCase().indexOf(needle) > -1)
      })
    },
    setModelA (val) {
      this.orgA = val
    },
    setModelB (val) {
      this.orgB = val
    },
    postForm: async function () {
      if (this.orgValidate()) {
        console.log('skljks')
        const q = `${process.env.api}/treaties`
        const payload = {
          creator_user_id: this.$store.state.user.uid,
          name: this.name,
          description: this.description,
          organization_a_id: this.organizationsObj[this.orgA],
          organization_b_id: this.organizationsObj[this.orgB],
          avatar_url: this.avatar_url,
          status: 'pending'
        }
        console.log(payload)
        const res = await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
        this.$router.push('/treaty/' + res.data.id)
      }
    },
    orgValidate: function () {
      if (!this.organizationsA.includes(this.orgA)) {
        console.log('aaaa')
        this.$q.notify({
          type: 'negative',
          message: 'Invalid Party A'
        })
        return false
      }
      if (!this.organizationsB.includes(this.orgB)) {
        console.log('bbbb')
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
