<template>
  <q-layout view="Lhh lpR fff" style="width:550px; max-width:99%;" container class="bg-white">
    <q-header class="bg-primary">
      <q-toolbar>
        <q-toolbar-title class="q-pl-lg">Create Treaty</q-toolbar-title>
        <q-btn flat v-close-popup round dense icon="close" />
      </q-toolbar>
    </q-header>
    <q-page-container>
      <q-page padding class="q-lt-lg">
        <q-form>
          <q-list class="full-width">
            <q-list>
              <q-item-section style="width:500px;">
                <q-input class="q-mb-sm" outlined v-model="name" label="Name" />
                <q-input class="q-mb-sm" outlined v-model="description" label="Description" />
                <q-input class="q-mb-sm" outlined v-model="avatar_url" label="Avatar URL" />
                <div class="q-mt-sm" v-for="(count, i) in provisions" :key="i">
                  <q-separator />
                  <div class="row" style="">
                    <div class="col col-10"><h6 class="caption text-grey">Provision {{i + 1}}</h6></div>
                    <div class="col text-right"><q-btn square color="grey" @click="removeProvision(i)" size="12px" class="q-mt-sm" icon="close" /></div>
                  </div>
                  <q-input class="q-mb-sm" filled v-model="provisionNames[count]" label="Title" />
                  <q-input type="textarea" class="q-mb-sm" filled v-model="provisionText[count]" label="Provision Text" />
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
      </q-page>
    </q-page-container>
  </q-layout>
</template>
<script>
export default {
  name: 'CreateTreaty',
  components: {},
  props: ['userOrganizationId', 'conflictId', 'reset'],
  data () {
    return {
      name: '',
      description: '',
      avatar_url: '',
      provisionCount: 0,
      provisions: [],
      provisionNames: [],
      provisionText: []
    }
  },
  methods: {
    postTreaty: async function () {
      const q = `${process.env.api}/treaties`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        organization_id: this.userOrganizationId,
        avatar_url: this.avatar_url,
        name: this.name,
        description: this.description,
        conflict_id: this.conflictId,
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
      this.reset()
    },
    removeProvision: function (index) {
      this.provisions.splice(index, 1)
    },
    addProvision: function () {
      this.provisionCount++
      this.provisions.push(this.provisionCount)
    }
  },
  mounted () {}
}
</script>
