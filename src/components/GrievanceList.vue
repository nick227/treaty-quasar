<template>
  <div>
  <q-item>
    <q-item-section top avatar>
      <q-avatar color="negative" text-color="white" icon="error" />
    </q-item-section>
    <q-item-section>
      <q-item-label>{{ title }}</q-item-label>
      <q-item-label caption lines="12">{{ description }}</q-item-label>
    </q-item-section>
    <q-item-section side top>
      <q-icon name="thumb_up_alt" color="blue" /> 544
    </q-item-section>
    <q-item-section side top>
      <q-icon name="thumb_down_alt" color="red" /> 33
    </q-item-section>
    </q-item>
      <q-expansion-item icon="comment" label="232 Comments" opened=true>
        <div class="q-pa-md full-width">
          <q-form>
    <q-input
      filled
      type="textarea"
      autogrow
      placeholder="Type comment here"
    />
            <div class="row">
    <q-space />
    <q-btn color="primary q-mt-sm">submit</q-btn>
  </div>
</q-form>
  </div>
  <q-list>
    <q-item class="q-pa-sm">
      <div class="row">
        <div class="col col-md-1"></div>
        <div class="col col-md-10">
      <div class="row">
      <q-avatar class="q-mr-md"><q-img rounded class="avatar" src="https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-vector-stock-91602735.jpg"></q-img></q-avatar>
        <h4>Nick says:</h4>
        </div>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
        </div>
        <div class="col col-md-1"></div>
      </div>
    </q-item>
  </q-list>
        <q-separator spaced inset />
</q-expansion-item>
</div>
</template>
<script>
export default {
  name: 'GrievanceList',
  methods: {
    showComments: function (event) {
      console.log(event)
    }
  },
  data () {
    return {
      commentForms: []
    }
  },
  props: {
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    }
  }
}

</script>
