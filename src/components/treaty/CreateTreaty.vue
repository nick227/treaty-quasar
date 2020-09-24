<template>
  <q-layout view="Lhh lpR fff" container class="bg-white river-width">
    <q-header class="bg-primary">
      <q-toolbar>
        <q-toolbar-title class="q-pl-lg">Create Treaty</q-toolbar-title>
        <q-btn flat v-close-popup round dense icon="close" />
      </q-toolbar>
    </q-header>
    <q-page-container>
      <q-page padding class="">
        <q-form>
          <q-list class="full-width">
            <q-list>
              <q-item-section class="full-width">
                <q-select class="q-mb-sm" v-if="!conflictId" outlined required transition-show use-input autofocus hide-selected fill-input input-debounce="0" behavior="menu" error-message emit-value label="Conflict" v-model="conflictSelect" :options="options" @filter="filterFn">
                  <template v-slot:no-option>
                    <q-item>
                      <q-item-section class="text-grey">
                        No results
                      </q-item-section>
                    </q-item>
                  </template>
                </q-select>
                <div v-if="!conflictId && !userOrganizationIdSelect" class="full-width text-right q-mb-sm">Conflict not listed?</div>
                <div v-if="!conflictId && !userOrganizationIdSelect" class="full-width text-center q-mb-sm">
                  <q-btn class="full-width" icon="add" label="ADD CONFLICT" />
                </div>
                <p v-if="userOrganizationNameSelect" class="q-pt-none">Creating as: {{ userOrganizationNameSelect }}</p>
                <q-input class="q-mb-sm" outlined required v-model="name" label="Name" />
                <q-input class="q-mb-sm" outlined required v-model="description" label="Description" />
                <q-input class="q-mb-sm" outlined required v-model="avatar_url" label="Avatar URL" />
                <div class="q-mt-sm" v-for="(count, i) in provisions" :key="i">
                  <q-separator />
                  <div class="row" style="">
                    <div class="col col-10">
                      <h6 class="caption text-grey">Provision {{i + 1}}</h6>
                    </div>
                    <div class="col text-right">
                      <q-btn square color="grey" @click="removeProvision(i)" size="12px" class="q-mt-sm" icon="close" />
                    </div>
                  </div>
                  <q-input class="q-mb-sm" required filled v-model="provisionNames[count]" label="Title" />
                  <q-input type="textarea" required class="q-mb-sm" filled v-model="provisionText[count]" label="Provision Text" />
                </div>
                <q-btn color="grey" @click="addProvision" class="q-mb-sm">
                  <q-icon left size="2em" name="add" />
                  <div>Add Provision</div>
                </q-btn>
                <q-btn color="primary" @click="postTreaty" class="">
                  <div>SUBMIT</div>
                </q-btn>
              </q-item-section>
            </q-list>
          </q-list>
        </q-form>
        <q-dialog v-model="verify_org" persistent>
          <q-card>
            <q-card-section class="row items-center">
              <q-avatar icon="done_outline" color="primary" text-color="white" /> <span class="q-ml-sm">Choose ONE organization to create as.</span> </q-card-section>
            <q-card-actions align="right">
              <q-btn flat label="Cancel" color="primary" v-close-popup />
              <q-btn flat :label="org_a.name" color="primary" @click="setOrg('org_a')" v-close-popup />
              <q-btn flat :label="org_b.name" color="primary" @click="setOrg('org_b')" v-close-popup />
            </q-card-actions>
          </q-card>
        </q-dialog>
      </q-page>
    </q-page-container>
  </q-layout>
</template>
<script>
export default {
  name: 'CreateTreaty',
  components: {},
  props: ['userOrganizationId', 'conflictId', 'reload'],
  data () {
    return {
      name: '',
      description: '',
      avatar_url: '',
      provisionCount: 0,
      provisions: [],
      provisionNames: [],
      provisionText: [],
      conflict: null,
      conflicts: [],
      options: [],
      conflictsObj: {},
      conflictSelect: null,
      conflictSelectId: null,
      userOrganizationIdSelect: null,
      userOrganizationNameSelect: null,
      verify_org: false,
      org_a: { name: '', id: '' },
      org_b: { name: '', id: '' }
    }
  },
  async created () {
    if (!this.conflictId) {
      this.getConflicts()
      this.options = this.conflicts
    }
  },
  watch: {
    conflictSelect: function (val) {
      this.org_a.name = this.conflictsObj[val].org_a.name
      this.org_b.name = this.conflictsObj[val].org_b.name
      this.org_a.id = this.conflictsObj[val].org_a.id
      this.org_b.id = this.conflictsObj[val].org_b.id
      this.conflictSelectId = this.conflictsObj[val].id
      this.verify_org = true
    }
  },
  methods: {
    setOrg (key) {
      this.userOrganizationIdSelect = this[key].id
      this.userOrganizationNameSelect = this[key].name
    },
    filterFn (val, update, abort) {
      if (val === '') {
        update(() => {
          this.options = this.conflicts
        })
        return
      }
      update(() => {
        const needle = val.toLocaleLowerCase()
        this.options = this.conflicts.filter(v => v.toLocaleLowerCase().indexOf(needle) > -1)
      })
    },
    setModel (val) {
      this.conflict = val
    },
    getConflicts: async function () {
      const q = `${process.env.api}/conflicts?filter[order]=name%20ASC&filter[include][0][relation]=organization_a&filter[include][1][relation]=organization_b`
      const conflicts = await this.$axios.get(q)
      this.conflicts = conflicts.data.map((obj) => { return obj.name })
      for (var i = 0, length1 = conflicts.data.length; i < length1; i++) {
        this.conflictsObj[conflicts.data[i].name] = { id: conflicts.data[i].id, org_a: conflicts.data[i].organization_a, org_b: conflicts.data[i].organization_b }
      }
    },
    postTreaty: async function () {
      const q = `${process.env.api}/treaties`
      const conflictId = this.conflictId ? this.conflictId : this.conflictSelectId
      const userOrganizationId = this.userOrganizationId ? this.userOrganizationId : this.userOrganizationIdSelect
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        organization_id: userOrganizationId,
        avatar_url: this.avatar_url,
        name: this.name,
        description: this.description,
        conflict_id: conflictId,
        status_id: 1
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
        .then((res) => {
          this.postProvisions(res.data.id)
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: err
          })
        })
    },
    postProvisions: async function (id) {
      const q = `${process.env.api}/treaty-provisions`
      let payload = {}
      this.provisionNames = this.provisionNames.filter(Object)
      this.provisionText = this.provisionText.filter(Object)
      for (let i = 0; i < this.provisionNames.length; i++) {
        payload = {
          treaty_id: id,
          creator_user_id: this.$store.state.user.uid,
          status_id: 1,
          title: this.provisionNames[i],
          description: this.provisionText[i],
          position: i
        }
        await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
          .catch((err) => {
            this.$q.notify({
              type: 'negative',
              message: err
            })
          })
        this.provisionNames[i] = ''
        this.provisionText[i] = ''
      }
      this.name = ''
      this.description = ''
      this.avatar_url = ''
      this.$q.notify({
        type: 'positive',
        message: 'Treaty created'
      })
      this.reload()
    },
    removeProvision: function (index) {
      this.provisions.splice(index, 1)
    },
    addProvision: function () {
      this.provisionCount++
      this.provisions.push(this.provisionCount)
    }
  }
}

</script>
