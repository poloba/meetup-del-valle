import gql from 'graphql-tag';

export const LOGIN = gql`
mutation Login($email: String!, $password: String!) {
  login(email: $email, password: $password) {
    token,
    user {
      id,
    }
  },
}
`;

export const SEND_RESET_PASSWORD = gql`
mutation SendResetPassword($email: String!) {
  sendResetPassword(email: $email)
}
`;

export const RESET_PASSWORD = gql`
mutation ResetPassword($token: String!, $password: String!) {
  resetPassword(token: $token, password: $password) {
    token,
    user {
      id,
    }
  },
}
`;

export const RESEND_CONFIRMATION_EMAIL = gql`
mutation ResendConfirmationEmail($email: String!) {
  resendConfirmationEmail(email: $email)
}
`;