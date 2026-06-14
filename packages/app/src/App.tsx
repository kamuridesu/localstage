import { createApp } from '@backstage/frontend-defaults';
import catalogPlugin from '@backstage/plugin-catalog/alpha';
import { navModule } from './modules/nav';

import {
  OpenIdConnectApi,
  ProfileInfoApi,
  BackstageIdentityApi,
  SessionApi,
  createApiRef,
  configApiRef,
  discoveryApiRef,
  oauthRequestApiRef,
} from '@backstage/core-plugin-api';

import { OAuth2 } from '@backstage/core-app-api';
import { SignInPageBlueprint } from '@backstage/plugin-app-react';
import { SignInPage } from '@backstage/core-components';

import {
  createFrontendModule,
  ApiBlueprint,
  useApi,
} from '@backstage/frontend-plugin-api';

const keycloakAuthApiRef = createApiRef<
  OpenIdConnectApi & ProfileInfoApi & BackstageIdentityApi & SessionApi
>({
  id: 'auth.keycloak',
});

const keycloakAuthApi = ApiBlueprint.make({
  name: 'keycloak',
  params: defineParams =>
    defineParams({
      api: keycloakAuthApiRef,
      deps: {
        discoveryApi: discoveryApiRef,
        oauthRequestApi: oauthRequestApiRef,
        configApi: configApiRef,
      },
      factory: ({ discoveryApi, oauthRequestApi, configApi }) => {
        return OAuth2.create({
          configApi,
          discoveryApi,
          oauthRequestApi,
          environment: configApi.getOptionalString('auth.environment'),
          provider: {
            id: 'oidc',
            title: 'Keycloak',
            icon: () => null,
          },
          defaultScopes: ['openid', 'profile', 'email'],
        });
      },
    }),
});

const signInPage = SignInPageBlueprint.make({
  params: {
    loader: async () => props => {
      const config = useApi(configApiRef);

      const isProduction =
        config.getOptionalString('auth.environment') === 'production';

      if (isProduction) {
        return (
          <SignInPage
            {...props}
            provider={{
              id: 'keycloak-auth-provider',
              title: 'keycloak',
              message: 'Sign In using Keycloak',
              apiRef: keycloakAuthApiRef,
            }}
          />
        );
      }
      return <SignInPage {...props} providers={['guest']} />;
    },
  },
});

export default createApp({
  features: [
    catalogPlugin,
    navModule,
    createFrontendModule({
      pluginId: 'app',
      extensions: [keycloakAuthApi, signInPage],
    }),
  ],
});
