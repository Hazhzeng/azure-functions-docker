$SASURL = "https://cloudbuildlinux.blob.core.windows.net/scm-releases/AfterBuild.zip?st=2019-06-24T20%3A24%3A23Z&se=2019-06-25T20%3A24%3A23Z&sp=rl&sv=2018-03-28&sr=b&sig=dZMmyO2WCUU73yg0yf82kUVUtwQwmzJrCB6kQnpyxzw%3D"
$old_id = (docker container ls -q --filter "name=functionhost")
$old_image = (docker container ls --filter "name=functionhost" --format "{{.Image}}")

if ($old_id) {
    docker container rm -f $old_id
}

$imagename = $args[0]
if (-not $imagename) {
    $imagename = $old_image
}

docker run --name functionhost --publish 8181:80 --device /dev/fuse --cap-add SYS_ADMIN `
 -e "APPSETTING_SCM_RUN_FROM_PACKAGE=$SASURL"`
 -e "SCM_RUN_FROM_PACKAGE=$SASURL"`
 -e "WEBSITE_PLACEHOLDER_MODE=1"`
 -e "AZURE_FUNCTIONS_ENVIRONMENT=development"`
 -e "CONTAINER_NAME=awesome_id"`
 -e "CONTAINER_ENCRYPTION_KEY=MDEyMzQ1Njc4OUFCQ0RFRjAxMjM0NTY3ODlBQkNERUY="`
 -e "WEBSITE_AUTH_ENCRYPTION_KEY=E782F47415EEC076F8087729FB30CF1CA1482610C2FA985E4F22531225722205"`
 -e "WEBSITE_SITE_NAME=azclidemo"`
 -e "WEBSITE_HOSTNAME=azclidemo.azurewebsites.com"`
 -e "WEBSITE_MOUNT_ENABLED=0" $imagename
