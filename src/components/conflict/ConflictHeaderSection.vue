<template>
  <div>
    <div class="row full-width">
      <div class="bg-grey-2 col col-md-5 q-pl-md"> <a class="cursor-pointer" @click="$router.push('/organization/'+org_a.id)"><h6><q-avatar size="40px" square class="q-mr-md"><q-img rounded class="q-mt-none" :src="org_a.avatar_url"></q-img></q-avatar>{{ org_a.name }}</h6></a> </div>
      <div class="bg-grey-2 col col-md-2 text-center">
        <h6>vs.</h6> </div>
      <div class="bg-grey-2 col col-md-5 text-right q-pr-md"> <a class="cursor-pointer" @click="$router.push('/organization/'+org_b.id)"><h6><q-avatar size="40px" square class="q-mr-md"><q-img rounded class="q-mt-none" :src="org_b.avatar_url"></q-img></q-avatar>{{ org_b.name }}</h6></a> </div>
    </div>
    <q-card class="q-pa-lg full-width full-height">
      <q-expansion-item v-model="expanded" switch-toggle-side dense-toggle label="Edit Conflict" class="absolute-right q-mr-lg q-mb-lg">
        <EditConflictWidget :name="name" :avatar_url="avatar_url" :description="description" :status="status" :id="id" :reload="reload" /> </q-expansion-item>
      <q-card-section horizontal class="full-width items-start">
        <q-img :src="avatar_url" style="width:20%;" />
        <q-card-section class="q-pb-md q-pt-none">
          <h2>{{ name }}</h2>
          <p class="q-pt-none" style="max-width:60%;">{{ description }}</p>
          <div class="row">
            <q-badge color="secondary" v-if="user_organization_name" :label="'Commenting as: ' + user_organization_name" />
          </div>
        </q-card-section>
      </q-card-section>
    </q-card>
  </div>
</template>
<script>
import EditConflictWidget from 'components/conflict/EditConflictWidget.vue'
export default {
  name: 'ConflictHeaderSection',
  props: ['name', 'avatar_url', 'description', 'status', 'id', 'reload', 'user_organization_name', 'org_a', 'org_b'],
  components: { EditConflictWidget },
  data () {
    return {
      expanded: false
    }
  },
  methods: {},
  mounted () {}
}
</script>
