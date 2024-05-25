@react.component
let make = (~children, ~href) => {
  <a href className="font-medium text-blue-600 dark:text-blue-500 hover:underline"> {children} </a>
}

module Page = {
  @react.component
  let make = (~children, ~page: Routes.page) => {
    <a
      onClick={_ => RescriptReactRouter.push(page->Routes.pageToUrlString)}
      className="font-medium text-blue-600 dark:text-blue-500 hover:underline">
      {children}
    </a>
  }
}
