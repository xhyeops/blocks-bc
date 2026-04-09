const MetaBg = <template>
  <div class="meta-bg-wrapper" aria-hidden="true">
    <div class="meta-bg"></div>
    <div class="meta-bg-gradient"></div>
    <div class="meta-bg-gradient-bottom"></div>
    <div class="meta-sidebar-bg"></div>
    <div class="meta-bg-icons">

      <div class="floating-icon floating-icon--plane">
        <svg>
          <use href="#blocks-plane"></use>
        </svg>
      </div>

      <div class="floating-icon floating-icon--chat">
        <svg>
          <use href="#blocks-chat"></use>
        </svg>
      </div>

      <div class="floating-icon floating-icon--quote">
        <svg>
          <use href="#blocks-quote"></use>
        </svg>
      </div>

      <div class="floating-icon floating-icon--bell">
        <svg>
          <use href="#blocks-bell"></use>
        </svg>
      </div>

      <div class="floating-icon floating-icon--sparkles">
        <svg>
          <use href="#blocks-sparkles"></use>
        </svg>
      </div>

      <div class="floating-icon floating-icon--reactions">
        <svg>
          <use href="#blocks-reactions"></use>
        </svg>
      </div>

    </div>
  </div>
</template>;

export default MetaBg;
