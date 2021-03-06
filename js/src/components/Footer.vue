<template>
  <footer class="footer" ref="footer">
    <picture>
      <source
        :srcset="`/img/pics/logo-horizontal-1024w.webp 1x, /img/pics/logo-horizontal-1920w.webp 2x`"
        type="image/webp"
      />
      <source
        :srcset="`/img/pics/logo-horizontal-1024w.png 1x, /img/pics/logo-horizontal-1920w.png 2x`"
        type="image/jpeg"
      />
      <img
        :src="`/img/pics/logo-horizontal-1024w.png`"
        alt=""
        width="1214"
        height="859"
        loading="lazy"
      />
    </picture>
    <ul>
      <li>
        <b-select
          v-if="$i18n"
          v-model="locale"
          :placeholder="$t('Select a language')"
        >
          <option v-for="(language, lang) in langs" :value="lang" :key="lang">
            {{ language }}
          </option>
        </b-select>
      </li>
      <li>
        <router-link :to="{ name: RouteName.ABOUT }">{{
          $t("About")
        }}</router-link>
      </li>
      <li>
        <router-link :to="{ name: RouteName.TERMS }">{{
          $t("Terms")
        }}</router-link>
      </li>
      <li>
        <a
          hreflang="en"
          href="https://framagit.org/framasoft/mobilizon/blob/master/LICENSE"
        >
          {{ $t("License") }}
        </a>
      </li>
    </ul>
    <div class="content has-text-centered">
      <i18n
        tag="span"
        path="Powered by {mobilizon}. © 2018 - {date} The Mobilizon Contributors - Made with the financial support of {contributors}."
      >
        <a slot="mobilizon" href="https://joinmobilizon.org">{{
          $t("Mobilizon")
        }}</a>
        <span slot="date">{{ new Date().getFullYear() }}</span>
        <a href="https://joinmobilizon.org/hall-of-fame" slot="contributors">{{
          $t("more than 1360 contributors")
        }}</a>
      </i18n>
    </div>
  </footer>
</template>
<script lang="ts">
import { Component, Vue, Watch } from "vue-property-decorator";
import { saveLocaleData } from "@/utils/auth";
import { loadLanguageAsync } from "@/utils/i18n";
import RouteName from "../router/name";
import langs from "../i18n/langs.json";

@Component
export default class Footer extends Vue {
  RouteName = RouteName;

  locale: string | null = this.$i18n.locale;

  langs: Record<string, string> = langs;

  // eslint-disable-next-line class-methods-use-this
  //get random(): number {
  //  return Math.floor(Math.random() * 4) + 1;
  //}

  @Watch("locale")
  // eslint-disable-next-line class-methods-use-this
  async updateLocale(locale: string): Promise<void> {
    if (locale) {
      await loadLanguageAsync(locale);
      saveLocaleData(locale);
    }
  }

  @Watch("$i18n.locale", { deep: true })
  updateLocaleFromI18n(locale: string): void {
    if (locale) {
      this.locale = locale;
    }
  }
}
</script>
<style lang="scss" scoped>
@import "~bulma/sass/utilities/mixins.sass";
footer.footer {
  color: #fff;
  display: flex;
  flex-direction: column;
  align-items: center;
  font-size: 14px;
  padding: 1rem 1.5rem;

  img {
    flex: 1;
    max-width: 40rem;
    @include mobile {
      max-width: 400px;
    }
  }

  div.content {
    flex: 1;
    margin-top: 24px;
  }

  ul {
    display: inline-flex;
    flex-wrap: wrap;
    justify-content: space-around;

    li {
      display: inline-flex;
      margin: auto 5px;
      a {
        font-size: 1.1rem;
      }
    }
  }

  a {
    color: $white;
    text-decoration: underline;
    text-decoration-color: $secondary;
  }

  ::v-deep span.select select {
    background: $background-color;
    color: $white;
  }
}
</style>
