<template>
  <div class="">
    <AddConflictItem
    class="full-width q-pa-sm q-mb-lg"
    :entityType="entityType"
    :userOrganizationId="userOrganizationId"
    :conflictId="conflictId"
    :orgA="orgA"
    :orgB="orgB"
    :reload="reload" />
    <q-table
      :data="sortedData"
      :columns="columns"
      row-key="id"
    >
      <template v-slot:top-right>
        <q-input borderless dense debounce="300" v-model="filter" placeholder="Search">
          <template v-slot:append>
            <q-icon name="search" />
          </template>
        </q-input>
      </template>
      <template v-slot:body="props">
        <q-tr :props="props">
          <q-td
            key="organization"
            :props="props"
          > <q-avatar class="q-mr-sm" round size="sm">
              <q-img :src="props.row.creator_organization_avatar" />
            </q-avatar>
            <router-link :to="'/organization/'+props.row.creator_organization_id">{{ props.row.creator_organization_name }}</router-link>
          </q-td>
          <q-td
            class="wrap"
            key="title"
            :props="props"
          >
            <p class="q-pa-none">{{ props.row.title }}</p>
            <p class="q-pa-none text-caption">created by: <router-link :to="'/profile/'+props.row.creator_id">{{ props.row.creator_name }}</router-link> {{ props.row.create_date }}
              <q-icon v-if="userCheck(props.row.creator_id)" name="edit" @click="editEntity(props.row.id, props.row.title)" class="cursor-pointer" clickable v-ripple size="13px" />
              <q-icon v-if="userCheck(props.row.creator_id)" name="delete" @click="promptDelete(props.row.id)" class="cursor-pointer" clickable v-ripple size="13px" />
            </p>
          </q-td>
          <q-td auto-width>
                    <LikeButtons
                    entityType='grievance'
                    :entityId="props.row.id"
                    :readonly="!orgVerify(orgA.id) ? true : false"
                    :organizationId="orgA.id" />
          </q-td>
          <q-td auto-width>
                    <LikeButtons
                    entityType='grievance'
                    :entityId="props.row.id"
                    :readonly="!orgVerify(orgB.id) ? true : false"
                    :organizationId="orgB.id" />
          </q-td>
        </q-tr>
        <q-tr class="sub-row" :props="props">
          <q-td colspan="100%" class="">
            <CommentsWidget
                  :entityId="props.row.id"
                  :entityType="entityType"
                  :userOrganizationId="userOrganizationId"
            ></CommentsWidget>
          </q-td>
        </q-tr>
      </template>
    </q-table>
  <q-dialog v-model="confirmDelete" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-avatar icon="check" color="primary" text-color="white" />
          <span class="q-ml-sm">Permanently delete this {{ entityType }}?</span>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancel" color="primary" v-close-popup />
          <q-btn flat label="DELETE FOREVER" @click="deleteEntity" color="primary" />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-dialog v-model="confirmEdit">
      <EditConflictItem :reload="getData" :editId="editId" :entityType="entityType" :editTitle="editTitle"  />
  </q-dialog>
  </div>
</template>
<script>
import EditConflictItem from 'components/conflict/EditConflictItem.vue'
import LikeButtons from 'components/widgets/LikeButtonsWidget.vue'
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import AddConflictItem from 'components/conflict/AddConflictItem.vue'
import { date } from 'quasar'
export default {
  name: 'ConflictEntitySection',
  props: ['userOrganizationId', 'orgA', 'orgB', 'conflictId', 'entityType', 'reload'],
  components: { AddConflictItem, CommentsWidget, LikeButtons, EditConflictItem },
  data () {
    return {
      confirmDelete: false,
      confirmEdit: false,
      deleteId: null,
      editId: null,
      editTitle: null,
      filter: '',
      entities: [],
      title: '',
      columns: [
        { name: 'organization', align: 'left', label: 'Organization', field: 'creator_organization_name', sortable: true },
        { name: 'title', align: 'left', label: this.entityType, field: 'title' },
        { name: 'orgA', align: 'left', label: this.orgA.name },
        { name: 'orgB', align: 'left', label: this.orgB.name }
      ]
    }
  },
  computed: {
    sortedData: function () {
      return this.entities.map((obj) => {
        if (typeof obj.likes !== 'object') {
          obj.likes = []
        }
        return {
          id: obj.id,
          conflict_id: obj.conflict_id,
          create_date: date.formatDate(obj.create_date, 'M/D/YY'),
          description: obj.description,
          title: obj.title,
          creator_organization_name: obj.organization.name,
          creator_organization_avatar: obj.organization.avatar_url,
          creator_organization_id: obj.organization.id,
          creator_name: obj.creator.name,
          creator_id: obj.creator.id,
          creator_avatar: obj.creator.avatar_url,
          creator_location: obj.creator.location,
          likes: obj.likes.map((o) => {
            return {
              liked: o.liked,
              creator_organization_name: o.organization.name,
              creator_name: o.creator.name,
              creator_avatar: o.creator.avatar_url
            }
          })
        }
      }).reverse()
    }
  },
  methods: {
    deleteEntity: async function () {
      this.confirm = false
      const q1 = `${process.env.api}/${this.entityType}s/${this.deleteId}/${this.entityType}-comments`
      const q2 = `${process.env.api}/${this.entityType}s/${this.deleteId}/${this.entityType}-likes`
      const q3 = `${process.env.api}/${this.entityType}s/${this.deleteId}`
      const self = this
      const queries = [q1, q2, q3]
      for (let i = 0; i < queries.length; i++) {
        deleteRow(queries[i], i)
      }
      async function deleteRow (q, count) {
        await self.$axios.delete(q)
          .then((res) => {
            if (count === 2) {
              self.reload()
              self.$q.notify({
                type: 'positive',
                message: 'Delete Success'
              })
            }
          })
          .catch((err) => {
            self.$q.notify({
              type: 'negative',
              message: 'Error updating: ' + err
            })
          })
      }
    },
    promptDelete: function (id) {
      this.deleteId = id
      this.confirmDelete = true
    },
    editEntity: function (id, title) {
      this.editId = id
      this.editTitle = title
      this.confirmEdit = true
    },
    orgVerify: function (id) {
      return id === this.userOrganizationId
    },
    userCheck: function (id) {
      return this.$errorHandler.isLoggedInUser(id)
    },
    getData: async function () {
      const q = `${process.env.api}/${this.entityType}s/?filter={"where": {"conflict_id":"${this.conflictId}"}, "include": [{"relation": "organization"}, {"relation": "creator"}, {"relation": "likes", "scope":{"include":[{"relation":"organization"}, {"relation":"creator"}]}}]}`
      const entities = await this.$axios.get(q)
      this.entities = entities.data
    }
  },
  created () {
    this.getData()
  }
}
</script>
