<template>
  <div class="editor">
    <QuillEditor
      ref="quillEditor"
      :content="modelValue"
      @update:content="handleEditorUpdate"
      :options="editorOptions"
    />
  </div>
</template>

<script>
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css'

export default {
  components: { QuillEditor },
  props: {
    modelValue: {
      type: String,
      required: true,
      default: () => ''
    }
  },
  emits: ['update:modelValue', 'image-upload'],
  methods: {
    handleEditorUpdate(content) {
      this.$emit('update:modelValue', content);
    }
  },
  data() {
    return {
      editorOptions: {
        modules: {
          toolbar: {
            container: [
            ['bold', 'italic', 'underline', 'strike'],
            ['blockquote', 'code-block'],
            [{ 'header': 1 }, { 'header': 2 }],
            [{ 'list': 'ordered' }, { 'list': 'bullet' }],
            [{ 'script': 'sub' }, { 'script': 'super' }],
            [{ 'indent': '-1' }, { 'indent': '+1' }],
            [{ 'direction': 'rtl' }],
            [{ 'size': ['small', false, 'large', 'huge'] }],
            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
            [{ 'color': [] }, { 'background': [] }],
            [{ 'font': [] }],
            [{ 'align': [] }],
            ['link', 'image', 'video'],
            ['clean']  // 清除格式
            ],
            handlers: {
              image: function() {
                const input = document.createElement('input');
                input.setAttribute('type', 'file');
                input.setAttribute('accept', 'image/*');
                input.onchange = async () => {
                  const file = input.files[0];
                  const url = await new Promise((resolve) => {
                    this.$emit('image-upload', file, resolve);
                  });
                  const range = this.quill.getSelection(true);
                  this.quill.insertEmbed(range.index, 'image', url);
                };
                input.click();
              }
            }
          }
        },
        placeholder: '请输入内容...',
        theme: 'snow'
      }
    }
  }
}
</script>

<style scoped>
.editor {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  padding: 10px;
  min-width: 98%;
  height: 60vh;
  overflow-y: auto;
}

:deep(.ql-container) {
  border: none !important;
  height: calc(100% - 42px);
}

:deep(.ql-editor) {
  height: 100%;
  overflow-y: visible;
}
:deep(.ql-toolbar) {
  border: 1px solid #dcdfe6 !important;
  border-radius: 4px;
  margin-bottom: 10px;
}
</style>