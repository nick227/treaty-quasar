<template>
  <div class="">
    <div class="row full-width q-pa-sm bg-grey-2">
      <div class="col col-md-5">
        <a class="cursor-pointer" @click="$router.push('/organization/'+org_a.id)">
            <q-avatar size="40px" square class=""><q-img rounded class="q-mt-none" :src="org_a.avatar_url"></q-img></q-avatar><br />
            {{ org_a.name }}
        </a>
      </div>
      <div class="col col-md-2 text-center q-pt-md">
        vs.
      </div>
      <div class="col col-md-5 text-right">
        <a class="cursor-pointer" @click="$router.push('/organization/'+org_b.id)">
            <q-avatar size="40px" square class=""><q-img rounded class="q-mt-none" :src="org_b.avatar_url"></q-img></q-avatar><br />
            {{ org_b.name }}
        </a>
      </div>
    </div>
    <q-card class="q-pl-lg q-pr-lg full-width full-height">
      <div class="row relative-position full-width" style="height: 40px;">
        <q-expansion-item v-model="expanded" switch-toggle-side dense-toggle label="Edit Conflict" class="absolute-right z-100">
          <EditConflictWidget :name="name" :avatar_url="avatar_url" :description="description" :status="status" :id="id" :reload="reloadComponent" />
        </q-expansion-item>
      </div>
      <q-card-section horizontal class="full-width items-start q-pb-lg">
        <q-img :src="avatar_url" style="width: 50%;" />
        <q-card-section class="q-pb-md q-pt-none" style="width: 50%;">
          <h5 class="q-pt-none">{{ name }}</h5>
          <p class="q-pt-none">{{ description }}</p>
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
  methods: {
    reloadComponent () {
      this.expanded = false
      this.reload()
    }
  },
  mounted () {}
}
</script>
